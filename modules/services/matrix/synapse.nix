# See: https://nixos.org/nixos/manual/index.html#module-services-matrix-synapse
{ config, lib, pkgs, ... }:
let
  matrixDomain = "matrix.${config.networking.domain}";
  synapseCfg = config.services.matrix-synapse;
in
lib.mkIf synapseCfg.enable {
  # Run Synapse
  services.matrix-synapse = {
    enable_registration = false;
    registration_shared_secret = lib.removeSuffix "\n"
      (builtins.readFile ../../../secrets/matrix-registration-shared-secret);
    server_name = config.networking.domain;
    max_upload_size = "250M";
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
    extraConfig = ''
      experimental_features:
        spaces_enabled: True
    '';
  };

  # Make sure that Postgres is setup for Synapse.
  services.postgresql = {
    ensureDatabases = [ "matrix-synapse" ];
    ensureUsers = [
      {
        name = "matrix-synapse";
        ensurePermissions."DATABASE \"matrix-synapse\"" = "ALL PRIVILEGES";
      }
    ];
  };

  # Set up nginx to forward requests properly.
  services.nginx.virtualHosts = {
    ${config.networking.domain} = {
      locations."= /.well-known/matrix/server".extraConfig =
        let
          server = { "m.server" = "${matrixDomain}:443"; };
        in
        ''
          add_header Content-Type application/json;
          return 200 '${builtins.toJSON server}';
        '';
      locations."= /.well-known/matrix/client".extraConfig =
        let
          client = {
            "m.homeserver" = { "base_url" = "https://${matrixDomain}"; };
            "m.identity_server" = { "base_url" = "https://vector.im"; };
          };
        in
        ''
          add_header Content-Type application/json;
          add_header Access-Control-Allow-Origin *;
          return 200 '${builtins.toJSON client}';
        '';
    };

    # Reverse proxy for Matrix client-server and server-server communication
    ${matrixDomain} = {
      enableACME = true;
      forceSSL = true;

      # If they access root, redirect to Element. If they access the API, then
      # forward on to Synapse.
      locations."/".extraConfig = ''
        return 301 https://app.element.io;
      '';
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
