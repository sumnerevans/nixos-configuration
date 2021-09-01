# See: https://nixos.org/nixos/manual/index.html#module-services-matrix-synapse
{ config, lib, pkgs, ... }: with lib;
let
  matrixDomain = "matrix.${config.networking.domain}";
  synapseCfg = config.services.matrix-synapse;
in
{
  config = mkIf synapseCfg.enable {
    # Run Synapse
    services.matrix-synapse = {
      package = pkgs.matrix-synapse.overridePythonAttrs (
        old: rec {
          pname = "matrix-synapse";
          version = "1.42.0rc2";

          src = pkgs.python3.pkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-ROajnIH/OEVim9ydjAfutTktW1zZP93pzh2RTY08Yvs=";
          };

          doCheck = false;
        }
      );

      logConfig = generators.toYAML {} {
        version = 1;
        formatters.journal_fmt.format = "%(name)s: [%(request)s] %(message)s";
        filters.context = {
          "()" = "synapse.util.logcontext.LoggingContextFilter";
          request = "";
        };
        handlers.journal = {
          class = "systemd.journal.JournalHandler";
          formatter = "journal_fmt";
          filters = [ "context" ];
          SYSLOG_IDENTIFIER = "synapse";
        };
        root = { level = "INFO"; handlers = [ "journal" ]; };
        disable_existing_loggers = false;
      };

      enable_registration = false;
      enable_metrics = true;
      server_name = config.networking.domain;
      max_upload_size = "250M";
      url_preview_enabled = true;
      listeners = [
        # CS API and Federation
        {
          port = 8008;
          bind_address = "0.0.0.0";
          tls = false;
          x_forwarded = true;
          resources = [
            { names = [ "client" ]; compress = true; }
            { names = [ "federation" ]; compress = false; }
          ];
        }

        # Metrics
        {
          port = 9009;
          bind_address = "0.0.0.0";
          tls = false;
          type = "metrics";
          resources = []; # need to specify because the module is stupid
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
    services.nginx = {
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
            proxyPass = "http://0.0.0.0:8008"; # without a trailing /
            extraConfig = ''
              access_log /var/log/nginx/matrix.access.log;
            '';
          };
        };
      };
    };

    # Make sure that Prometheus is setup for Synapse.
    services.prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "synapse";
          scrape_interval = "15s";
          metrics_path = "/_synapse/metrics";
          static_configs = [ { targets = [ "0.0.0.0:9009" ]; } ];
        }
      ];
    };

    # Add a backup service.
    services.backup.backups.matrix = {
      path = config.services.matrix-synapse.dataDir;
    };
  };
}
