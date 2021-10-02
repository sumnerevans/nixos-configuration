# See: https://nixos.org/nixos/manual/index.html#module-services-matrix-synapse
{ config, lib, pkgs, ... }: with lib;
let
  matrixDomain = "matrix.${config.networking.domain}";
  cfg = config.services.matrix-synapse-custom;

  # Custom package that tracks with the latest release of Synapse.
  package = pkgs.matrix-synapse.overridePythonAttrs (
    old: rec {
      pname = "matrix-synapse";
      version = "1.44.0rc2";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-kX68TYMv8WH3qFSCDQY0HkLQ/CEEIAYoQTJy/zUzsFg=";
      };

      # Enable Redis support
      propagatedBuildInputs = with pkgs.python3Packages; old.propagatedBuildInputs ++ [
        hiredis
        txredisapi
      ];

      doCheck = false;
    }
  );

  yamlFormat = pkgs.formats.yaml { };

  logConfigYaml = {
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

  # This is organized to match the sections in
  # https://github.com/matrix-org/synapse/blob/develop/docs/sample_config.yaml
  yamlConfig = {
    # Server
    server_name = config.networking.domain;
    pid_file = "/run/matrix-synapse.pid";
    listeners = [
      # CS API and Federation
      {
        type = "http";
        port = 8008;
        bind_address = "0.0.0.0";
        tls = false;
        x_forwarded = true;
        resources = [
          { names = [ "client" "federation" ]; compress = false; }
        ];
      }

      # Metrics
      {
        port = 9009;
        bind_address = "0.0.0.0";
        tls = false;
        type = "metrics";
      }

      # TODO add replication
    ];

    # Caching
    event_cache_size = "25K";
    caches.global_factor = 1.0;

    # Database
    database = {
      name = "psycopg2";
      args = { user = "matrix-synapse"; database = "matrix-synapse"; };
    };

    # Logging
    log_config = yamlFormat.generate "matrix-synapse-log-config.yaml" logConfigYaml;

    # Media store
    media_store_path = "${cfg.dataDir}/media";
    max_upload_size = "250M";
    url_preview_enabled = true;
    url_preview_ip_range_blacklist = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "100.64.0.0/10"
      "169.254.0.0/16"
      "::1/128"
      "fe80::/64"
      "fc00::/7"
    ];

    # TURN
    # Configure coturn to point at the matrix.org servers.
    # TODO actually figure this out eventually
    turn_uris = [
      "turn:turn.matrix.org?transport=udp"
      "turn:turn.matrix.org?transport=tcp"
    ];
    turn_shared_secret = "n0t4ctuAllymatr1Xd0TorgSshar3d5ecret4obvIousreAsons";
    turn_user_lifetime = "1h";

    # Registration
    enable_registration = false;
    registration_shared_secret = removeSuffix "\n" (readFile cfg.registrationSharedSecretFile);

    # Metrics
    enable_metrics = true;
    report_stats = true;

    # Signing Keys
    signing_key_path = "${cfg.dataDir}/homeserver.signing.key";

    # TODO email
  };

  configFile = yamlFormat.generate "matrix-synapse-config.yaml" yamlConfig;
in
{
  imports = [
    ./cleanup-synapse.nix
  ];

  options = {
    services.matrix-synapse-custom = {
      enable = mkEnableOption "Synapse, the reference Matrix homeserver";

      appServiceConfigFiles = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          A list of application service config file to use.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/matrix-synapse";
        description = ''
          The directory where matrix-synapse stores its stateful data such as
          certificates, media and uploads.
        '';
      };

      registrationSharedSecretFile = mkOption {
        type = types.path;
        description = ''
          The path to a file that contains the shared registration secret.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    # Create a user and group for Synapse
    users.users.matrix-synapse = {
      group = "matrix-synapse";
      home = cfg.dataDir;
      createHome = true;
      shell = "${pkgs.bash}/bin/bash";
      uid = config.ids.uids.matrix-synapse;
    };

    users.groups.matrix-synapse = {
      gid = config.ids.gids.matrix-synapse;
    };

    # Run Synapse
    systemd.services.matrix-synapse = {
      description = "Synapse Matrix homeserver";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${package}/bin/homeserver \
          --config-path ${configFile} \
          --keys-directory ${cfg.dataDir} \
          --generate-keys
      '';
      serviceConfig = {
        Type = "notify";
        User = "matrix-synapse";
        Group = "matrix-synapse";
        WorkingDirectory = cfg.dataDir;
        ExecStartPre = [
          ("+" + (pkgs.writeShellScript "matrix-synapse-fix-permissions" ''
            chown matrix-synapse:matrix-synapse ${cfg.dataDir}/homeserver.signing.key
            chmod 0600 ${cfg.dataDir}/homeserver.signing.key
          ''))
        ];
        ExecStart = ''
          ${package}/bin/homeserver \
            --config-path ${configFile} \
            --keys-directory ${cfg.dataDir}
        '';
        ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
        UMask = "0077";
      };
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
          static_configs = [{ targets = [ "0.0.0.0:9009" ]; }];
        }
      ];
    };

    # Add a backup service.
    services.backup.backups.matrix = {
      path = config.services.matrix-synapse.dataDir;
    };
  };
}