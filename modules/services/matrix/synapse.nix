# See: https://nixos.org/nixos/manual/index.html#module-services-matrix-synapse
{ config, lib, pkgs, ... }:
let
  matrixDomain = "matrix.${config.networking.domain}";
  synapseCfg = config.services.matrix-synapse;
in
lib.mkIf synapseCfg.enable {
  # Run Synapse
  services.matrix-synapse = {
    package = pkgs.matrix-synapse.overridePythonAttrs (old: rec {
      pname = "matrix-synapse";
      version = "1.35.0rc1";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-/MMua3O2fofdTYOZZ0BsLeIfgkC2Q5SnYaY7VVjefn8=";
      };

      propagatedBuildInputs = old.propagatedBuildInputs ++ [
        pkgs.python3.pkgs.ijson
      ];

      checkPhase = ''
        # these tests need the optional dependency 'hiredis'
        rm -r tests/replication
        rm -r tests/module_api
        PYTHONPATH=".:$PYTHONPATH" ${pkgs.python3.interpreter} -m twisted.trial tests
      '';
    });

    enable_registration = false;
    server_name = config.networking.domain;
    max_upload_size = "250M";
    url_preview_enabled = true;
    listeners = [
      {
        port = 8008;
        bind_address = "::1";
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = [ "client" "federation" ];
            compress = false;
          }
        ];
      }
    ];
  };

  # Make sure that Postgres is setup for Synapse.
  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  # Set up nginx to forward requests properly.
  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    ${config.networking.domain} = {
      enableACME = true;
      forceSSL = true;

      locations =
        let
          server = { "m.server" = "${matrixDomain}:443"; };
          client = {
            "m.homeserver" = { "base_url" = "https://${matrixDomain}"; };
            "m.identity_server" = { "base_url" = "https://vector.im"; };
          };
        in
        {
          "= /.well-known/matrix/server" = {
            extraConfig = ''
              add_header Content-Type application/json;
            '';
            return = "200 '${builtins.toJSON server}'";
          };
          "= /.well-known/matrix/client" = {
            extraConfig = ''
              add_header Content-Type application/json;
              add_header Access-Control-Allow-Origin *;
            '';
            return = "200 '${builtins.toJSON client}'";
          };
        };
    };

    # Reverse proxy for Matrix client-server and server-server communication
    ${matrixDomain} = {
      enableACME = true;
      forceSSL = true;

      # If they access root, redirect to Element. If they access the API, then
      # forward on to Synapse.
      locations."/".return = "301 https://app.element.io";
      locations."/_matrix" = {
        proxyPass = "http://[::1]:8008"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/matrix.access.log;
        '';
      };
    };
  };

  # Add a backup service.
  services.backup.backups.matrix = {
    path = config.services.matrix-synapse.dataDir;
  };
}
