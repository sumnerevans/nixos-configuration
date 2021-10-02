{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.linkedin-matrix;
  synapseCfg = config.services.matrix-synapse-custom;

  linkedin-matrix = pkgs.callPackage ../../../pkgs/linkedin-matrix.nix {};

  linkedinMatrixAppserviceConfig = {
    id = "linkedin";
    url = "http://${cfg.listenAddress}:${toString cfg.listenPort}";
    as_token = cfg.appServiceToken;
    hs_token = cfg.homeserverToken;
    rate_limited = false;
    sender_localpart = "XDUsekmAmWcmL1FWrgZ8E7ih-p0vffI3kMiezV43Sw29GLBQAQ-0_GRJXMQXlVb0";
    namespaces = {
      users = [
        { regex = "@li_.*:sumnerevans.com"; exclusive = true; }
        { regex = "@linkedinbot:sumnerevans.com"; exclusive = true; }
      ];
      aliases = [];
      rooms = [];
    };
  };

  linkedinMatrixAppserviceConfigYaml = pkgs.writeText "linkedin-matrix-registration.yaml" (
    generators.toYAML {} linkedinMatrixAppserviceConfig
  );

  linkedinMatrixConfig = {
    homeserver = {
      address = "http://localhost:8008";
      domain = config.networking.domain;
      verify_ssl = false;
      asmux = false;
      http_retry_count = 4;
    };

    metrics = {
      enabled = true;
      listen_port = 9010;
    };

    appservice = {
      address = "http://${cfg.listenAddress}:${toString cfg.listenPort}";
      hostname = cfg.listenAddress;
      port = cfg.listenPort;
      max_body_size = 1;
      database = "postgresql://linkedinmatrix:linkedinmatrix@localhost/linkedin-matrix";
      database_opts = { min_size = 5; max_size = 10; };
      id = "linkedin";
      bot_username = cfg.botUsername;
      bot_displayname = "LinkedIn bridge bot";
      bot_avatar = "mxc://sumnerevans.com/XMtwdeUBnxYvWNFFrfeTSHqB";
      as_token = cfg.appServiceToken;
      hs_token = cfg.homeserverToken;

      provisioning = {
        enabled = true;
        prefix = "/provision";
        shared_secret = "supersecrettoken"; # provisioning API is not public
      };
    };

    bridge = {
      username_template = "li_{userid}";
      displayname_template = "{displayname}";
      displayname_preference = [ "name" "first_name" ];
      set_topic_on_dms = true;
      command_prefix = "!li";
      initial_chat_sync = 20;
      invite_own_puppet_to_pm = true;
      sync_with_custom_puppets = true;
      sync_direct_chat_list = true;
      presence = false;
      update_avatar_initial_sync = true;
      encryption = {
        allow = true;
        default = true;
        key_sharing = {
          allow = true;
          require_cross_signing = false;
          require_verification = true;
        };
      };
      delivery_receipts = true;
      backfill = {
        invite_own_puppet = true;
        initial_limit = 20;
        missed_limit = 20;
        disable_notifications = true;
      };
      temporary_disconnect_notices = true;
      mute_bridging = true;
      permissions = {
        "nevarro.space" = "user";
        "@sumner:sumnerevans.com" = "admin";
      };
    };

    logging = {
      version = 1;

      formatters.journal_fmt.format = "[%(name)s] %(message)s";
      handlers = {
        journal = {
          class = "systemd.journal.JournalHandler";
          formatter = "journal_fmt";
          SYSLOG_IDENTIFIER = "linkedin-matrix";
        };
      };
      loggers = {
        aiohttp.level = "DEBUG";
        mau.level = "DEBUG";
        paho.level = "DEBUG";
        root.level = "DEBUG";
      };
      root = { level = "DEBUG"; handlers = [ "journal" ]; };
    };
  };

  linkedinMatrixConfigYaml = pkgs.writeText "linkedin-config.yaml" (
    generators.toYAML {} linkedinMatrixConfig
  );
in
{
  options = {
    services.linkedin-matrix = {
      enable = mkEnableOption "linkedin-matrix, a LinkedIn Messaging <-> Matrix bridge.";
      useLocalSynapse = mkOption {
        type = types.bool;
        default = true;
        description = "Whether or not to use the local synapse instance.";
      };
      homeserver = mkOption {
        type = types.str;
        default = "http://localhost:8008";
        description = "The URL of the Matrix homeserver.";
      };
      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The address for linkedin-matrix to listen on.";
      };
      listenPort = mkOption {
        type = types.int;
        default = 9899;
        description = "The port for linkedin-matrix to listen on.";
      };
      botUsername = mkOption {
        type = types.str;
        default = "linkedinbot";
        description = "The localpart of the linkedin-matrix admin bot's username.";
      };
      appServiceToken = mkOption {
        type = types.str;
        description = ''
          This is the token that the app service should use as its access_token
          when using the Client-Server API. This can be anything you want.
        '';
      };
      homeserverToken = mkOption {
        type = types.str;
        description = ''
          This is the token that the homeserver will use when sending requests
          to the app service. This can be anything you want.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    meta.maintainers = [ maintainers.sumnerevans ];

    assertions = [
      {
        assertion = cfg.useLocalSynapse -> config.services.matrix-synapse-custom.enable;
        message = ''
          LinkedIn must be running on the same server as Synapse if
          'useLocalSynapse' is enabled.
        '';
      }
    ];

    services.matrix-synapse-custom.appServiceConfigFiles = mkIf cfg.useLocalSynapse [
      linkedinMatrixAppserviceConfigYaml
    ];

    # Create a user for linkedin-matrix.
    users.users.linkedinmatrix = {
      group = "linkedinmatrix";
      isSystemUser = true;
    };
    users.groups.linkedinmatrix = {};

    # Create a database user for linkedin-matrix
    services.postgresql.ensureDatabases = [ "linkedin-matrix" ];
    services.postgresql.ensureUsers = [
      {
        name = "linkedinmatrix";
        ensurePermissions = {
          "DATABASE \"linkedin-matrix\"" = "ALL PRIVILEGES";
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
    ];

    systemd.services.linkedin-matrix = {
      description = "LinkedIn Messaging <-> Matrix Bridge";
      after = optional cfg.useLocalSynapse "matrix-synapse.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "linkedinmatrix";
        Group = "linkedinmatrix";
        ExecStart = ''
          ${linkedin-matrix}/bin/linkedin-matrix \
            --config ${linkedinMatrixConfigYaml} \
            --no-update
        '';
        Restart = "on-failure";
      };
    };

    services.prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "linkedinmatirx";
          scrape_interval = "15s";
          metrics_path = "/";
          static_configs = [ { targets = [ "0.0.0.0:9010" ]; } ];
        }
      ];
    };
  };
}
