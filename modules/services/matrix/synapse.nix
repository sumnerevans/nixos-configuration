# See: https://nixos.org/nixos/manual/index.html#module-services-matrix-synapse
{ config, lib, pkgs, ... }: with lib;
let
  matrixDomain = "matrix.${config.networking.domain}";
  synapseCfg = config.services.matrix-synapse;
  prodSynapse = synapseCfg.isProd;
in
{
  options = {
    services.matrix-synapse.isProd = mkEnableOption "configuring Synapse for a production environment" // {
      default = true;
    };
  };

  config = mkIf synapseCfg.enable {
    # Run Synapse
    services.matrix-synapse = {
      package = pkgs.matrix-synapse.overridePythonAttrs (
        old: rec {
          pname = "matrix-synapse";
          version = "1.37.0rc1";

          src = pkgs.python3.pkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-897fblOwxPMn+VLG40Tb4DlRD2Lf2lvypvIaS2l1IHY=";
          };

          doCheck = false;
        }
      );

      database_type = mkIf (!prodSynapse) "sqlite3";
      enable_registration = !prodSynapse;
      server_name = if prodSynapse then config.networking.domain else "localhost";
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

      # Configure coturn to point at the matrix.org servers.
      # TODO actually figure this out eventually
      turn_uris = [
        "turn:turn.matrix.org?transport=udp"
        "turn:turn.matrix.org?transport=tcp"
      ];
      turn_shared_secret = "n0t4ctuAllymatr1Xd0TorgSshar3d5ecret4obvIousreAsons";
      turn_user_lifetime = "1h";
    };

    # Make sure that Postgres is setup for Synapse.
    services.postgresql = mkIf prodSynapse {
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
    services.nginx = mkIf prodSynapse {
      enable = true;
      virtualHosts = {
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
    };

    # Add a backup service.
    services.backup.backups.matrix = mkIf prodSynapse {
      path = config.services.matrix-synapse.dataDir;
    };
  };
}
