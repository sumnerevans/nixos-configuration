# See: https://nixos.org/nixos/manual/index.html#module-services-matrix-synapse
{ config, lib, pkgs, ... }: with lib;
let
  matrixDomain = "matrix.${config.networking.domain}";
  cfg = config.services.matrix-synapse-custom;

  # Custom package that tracks with the latest release of Synapse.
  package = pkgs.matrix-synapse.overridePythonAttrs (
    old: rec {
      pname = "matrix-synapse";
      version = "1.45.0rc1";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-1bdX/zUPJfdLZTE9bs5/uayyncDPBr3Zi5SrYqc5PpE=";
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

  sharedConfig = (import ./configs/shared-config.nix ({ inherit config lib pkgs; }));
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
      newConfig = {
        # The replication listener on the main synapse process.
        worker_replication_host = "127.0.0.1";
        worker_replication_http_port = 9093;

        # Default to generic worker.
        worker_app = "synapse.app.generic_worker";
      } // config;
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

  synchotron1ConfigFile = yamlFormat.generate
    "synchotron-1.yaml"
    (mkSynapseWorkerConfig 9104 {
      worker_name = "synchotron1";
      # The event persister needs a replication listener
      worker_listeners = [
        {
          type = "http";
          port = 8010;
          bind_address = "127.0.0.1";
          resources = [{ names = [ "client" ]; }];
        }
      ];
    });

  mediaRepo1ConfigFile = yamlFormat.generate
    "media-repo-1.yaml"
    (mkSynapseWorkerConfig 9105 {
      worker_name = "media_repo1";
      worker_app = "synapse.app.media_repository";
      # The event persister needs a replication listener
      worker_listeners = [
        {
          type = "http";
          port = 8011;
          bind_address = "127.0.0.1";
          resources = [{ names = [ "media" ]; }];
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

    # Run the federation reader worker
    systemd.services.matrix-synapse-federation-reader1 = mkSynapseWorkerService {
      description = "Synapse Matrix federation reader 1";
      serviceConfig.ExecStart = ''
        ${package.python.withPackages (ps: [(package.python.pkgs.toPythonModule package)])}/bin/python -m synapse.app.generic_worker \
          --config-path ${sharedConfigFile} \
          --config-path ${federationReader1ConfigFile} \
          --keys-directory ${cfg.dataDir}
      '';
    };

    # Run the event persister worker
    systemd.services.matrix-synapse-event-persister1 = mkSynapseWorkerService {
      description = "Synapse Matrix event persister 1";
      serviceConfig.ExecStart = ''
        ${package.python.withPackages (ps: [(package.python.pkgs.toPythonModule package)])}/bin/python -m synapse.app.generic_worker \
          --config-path ${sharedConfigFile} \
          --config-path ${eventPersister1ConfigFile} \
          --keys-directory ${cfg.dataDir}
      '';
    };

    # Run the synchotron worker
    systemd.services.matrix-synapse-synchotron1 = mkSynapseWorkerService {
      description = "Synapse Matrix synchotron 1";
      serviceConfig.ExecStart = ''
        ${package.python.withPackages (ps: [(package.python.pkgs.toPythonModule package)])}/bin/python -m synapse.app.generic_worker \
          --config-path ${sharedConfigFile} \
          --config-path ${synchotron1ConfigFile} \
          --keys-directory ${cfg.dataDir}
      '';
    };

    # Run the media repo worker
    systemd.services.matrix-synapse-media-repo1 = mkSynapseWorkerService {
      description = "Synapse Matrix media repo 1";
      serviceConfig.ExecStart = ''
        ${package.python.withPackages (ps: [(package.python.pkgs.toPythonModule package)])}/bin/python -m synapse.app.media_repository \
          --config-path ${sharedConfigFile} \
          --config-path ${mediaRepo1ConfigFile} \
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
          locations."/_matrix/federation/" = {
            proxyPass = "http://0.0.0.0:8009"; # without a trailing /
            extraConfig = ''
              access_log /var/log/nginx/matrix-federation.access.log;
            '';
          };
          locations."~ ^/_matrix/client/.*/(sync|events|initialSync)" = {
            proxyPass = "http://0.0.0.0:8010"; # without a trailing /
            extraConfig = ''
              access_log /var/log/nginx/matrix-synchotron.access.log;
            '';
          };
          locations."~ ^/_matrix/media" = {
            proxyPass = "http://0.0.0.0:8011"; # without a trailing /
            extraConfig = ''
              access_log /var/log/nginx/matrix-media-repo.access.log;
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
            {
              # Synchotron 1
              targets = [ "0.0.0.0:9104" ];
              labels = { instance = matrixDomain; job = "synchotron"; index = "1"; };
            }
            {
              # Media repo 1
              targets = [ "0.0.0.0:9105" ];
              labels = { instance = matrixDomain; job = "media_repo"; index = "1"; };
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
