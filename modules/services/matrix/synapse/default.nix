# See: https://nixos.org/nixos/manual/index.html#module-services-matrix-synapse
{ config, lib, pkgs, ... }: with lib;
let
  matrixDomain = "matrix.${config.networking.domain}";
  cfg = config.services.matrix-synapse-custom;

  # Custom package that tracks with the latest release of Synapse.
  package = pkgs.matrix-synapse.overridePythonAttrs (
    old: rec {
      pname = "matrix-synapse";
      version = "1.44.0";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-oH8FXHSa120/Fys21UJfAAFPehJxEbQ8Op98PYkK8dE=";
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

  logConfig = {
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
  sharedConfig = {
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
          { names = [ "federation" "client" ]; compress = false; }
        ];
      }

      # Metrics
      {
        port = 9009;
        bind_address = "0.0.0.0";
        tls = false;
        type = "metrics";
      }

      # Replication
      {
        type = "http";
        port = 9093;
        bind_address = "127.0.0.1";
        resources = [{ names = [ "replication" ]; }];
      }
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
    log_config = yamlFormat.generate "matrix-synapse-log-config.yaml" logConfig;

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

    # API Configuration
    app_service_config_files = cfg.appServiceConfigFiles;

    # Signing Keys
    signing_key_path = "${cfg.dataDir}/homeserver.signing.key";
    trusted_key_servers = [
      { server_name = "matrix.org"; }
    ];
    suppress_key_server_warning = true;

    # TODO email?

    # Workers
    send_federation = false;
    federation_sender_instances = [ "federation_sender1" ];
    instance_map = {
      event_persister1 = {
        host = "localhost";
        port = 9091;
      };
    };

    stream_writers = {
      events = "event_persister1";
      typing = "event_persister1";
    };

    redis = {
      enabled = true;
    };
  };

  sharedConfigFile = yamlFormat.generate
    "matrix-synapse-config.yaml"
    sharedConfig;

  mkSynapseWorkerService = config: recursiveUpdate config {
    after = [ "matrix-synapse.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "notify";
      User = "matrix-synapse";
      Group = "matrix-synapse";
      WorkingDirectory = cfg.dataDir;
      ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
      Restart = "on-failure";
      UMask = "0077";
    };
  };

  mkSynapseWorkerConfig = port: config:
    let
      newConfig = config // {
        # The replication listener on the main synapse process.
        worker_replication_host = "127.0.0.1";
        worker_replication_http_port = 9093;
      };
      newWorkerListeners = (config.worker_listeners or [ ]) ++ [
        {
          type = "metrics";
          bind_address = "";
          port = port;
        }
      ];
    in
    newConfig // { worker_listeners = newWorkerListeners; };

  federationSender1ConfigFile = yamlFormat.generate
    "federation-sender-1.yaml"
    (mkSynapseWorkerConfig 9101 {
      worker_app = "synapse.app.federation_sender";
      worker_name = "federation_sender1";
    });

  federationReader1ConfigFile = yamlFormat.generate
    "federation-reader-1.yaml"
    (mkSynapseWorkerConfig 9102 {
      worker_app = "synapse.app.generic_worker";
      worker_name = "federation_reader1";
      worker_listeners = [
        # Federation
        {
          type = "http";
          port = 8009;
          bind_address = "0.0.0.0";
          tls = false;
          x_forwarded = true;
          resources = [
            { names = [ "federation" ]; compress = false; }
          ];
        }
      ];
    });

  eventPersister1ConfigFile = yamlFormat.generate
    "event-persister-1.yaml"
    (mkSynapseWorkerConfig 9103 {
      worker_app = "synapse.app.generic_worker";
      worker_name = "event_persister1";
      # The event persister needs a replication listener
      worker_listeners = [
        {
          type = "http";
          port = 9091;
          bind_address = "127.0.0.1";
          resources = [{ names = [ "replication" ]; }];
        }
      ];
    });
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

    # Run the main Synapse process
    systemd.services.matrix-synapse = {
      description = "Synapse Matrix homeserver";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${package}/bin/homeserver \
          --config-path ${sharedConfigFile} \
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
            --config-path ${sharedConfigFile} \
            --keys-directory ${cfg.dataDir}
        '';
        ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
        UMask = "0077";
      };
    };

    # Run the federation sender worker
    systemd.services.matrix-synapse-federation-sender1 = mkSynapseWorkerService {
      description = "Synapse Matrix federation sender 1";
      serviceConfig.ExecStart = ''
        ${package.python.withPackages (ps: [(package.python.pkgs.toPythonModule package)])}/bin/python -m synapse.app.federation_sender \
          --config-path ${sharedConfigFile} \
          --config-path ${federationSender1ConfigFile} \
          --keys-directory ${cfg.dataDir}
      '';
    };

    # Run the federation sender worker
    systemd.services.matrix-synapse-federation-reader1 = mkSynapseWorkerService {
      description = "Synapse Matrix federation reader 1";
      serviceConfig.ExecStart = ''
        ${package.python.withPackages (ps: [(package.python.pkgs.toPythonModule package)])}/bin/python -m synapse.app.generic_worker \
          --config-path ${sharedConfigFile} \
          --config-path ${federationReader1ConfigFile} \
          --keys-directory ${cfg.dataDir}
      '';
    };

    # Run the federation sender worker
    systemd.services.matrix-synapse-event-persister1 = mkSynapseWorkerService {
      description = "Synapse Matrix event persister 1";
      serviceConfig.ExecStart = ''
        ${package.python.withPackages (ps: [(package.python.pkgs.toPythonModule package)])}/bin/python -m synapse.app.generic_worker \
          --config-path ${sharedConfigFile} \
          --config-path ${eventPersister1ConfigFile} \
          --keys-directory ${cfg.dataDir}
      '';
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

    # Ensure that Redis is setup for Synapse.
    services.redis.enable = true;

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
          locations."/_matrix/federation/v1/send/" = {
            proxyPass = "http://0.0.0.0:8009"; # without a trailing /
            extraConfig = ''
              access_log /var/log/nginx/matrix-federation.access.log;
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
          static_configs = [
            {
              targets = [ "0.0.0.0:9009" ];
              labels = { instance = matrixDomain; job = "master"; index = "1"; };
            }
            {
              # Federation sender 1
              targets = [ "0.0.0.0:9101" ];
              labels = { instance = matrixDomain; job = "federation_sender"; index = "1"; };
            }
            {
              # Federation reader 1
              targets = [ "0.0.0.0:9102" ];
              labels = { instance = matrixDomain; job = "federation_reader"; index = "1"; };
            }
            {
              # Event persister 1
              targets = [ "0.0.0.0:9103" ];
              labels = { instance = matrixDomain; job = "event_persister"; index = "1"; };
            }
          ];
        }
      ];
    };

    # Add a backup service.
    services.backup.backups.matrix = {
      path = config.services.matrix-synapse.dataDir;
    };
  };
}
