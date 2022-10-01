{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.mautrix-discord;
  synapseCfg = config.services.matrix-synapse-custom;

  mautrix-discord = pkgs.callPackage ../../../pkgs/mautrix-discord.nix { };

  mautrixDiscordAppserviceConfig = {
    id = "discord";
    url = "http://${cfg.listenAddress}:${toString cfg.listenPort}";
    as_token = cfg.appServiceToken;
    hs_token = cfg.homeserverToken;
    rate_limited = false;
    sender_localpart = "LI6W2mH43X68rSiZ1YLAQCSLtuSZlPBt";
    namespaces = {
      users = [
        { regex = "^@discord_[0-9]+:nevarro.space$"; exclusive = true; }
        { regex = "^@discordbot:nevarro.space$"; exclusive = true; }
      ];
      aliases = [ ];
      rooms = [ ];
    };
  };

  yamlFormat = pkgs.formats.yaml { };

  mautrixDiscordAppserviceConfigYaml = yamlFormat.generate "mautrix-discord-registration.yaml" mautrixDiscordAppserviceConfig;

  mautrixDiscordConfig = {
    homeserver = {
      address = cfg.homeserver;
      domain = config.networking.domain;
    };

    metrics = {
      enabled = true;
      listen_port = 9011;
    };

    appservice = {
      address = "http://${cfg.listenAddress}:${toString cfg.listenPort}";
      hostname = cfg.listenAddress;
      port = cfg.listenPort;
      max_body_size = 1;
      database = "postgresql://mautrixdiscord:mautrixdiscord@localhost/mautrix-disocrd";
      database_opts = { min_size = 5; max_size = 10; };
      id = "discord";
      bot_username = cfg.botUsername;
      bot_displayname = "Discord bridge bot";
      bot_avatar = "mxc://nevarro.space/LWsPMGFektATJpgbSyfULDKR";
      as_token = cfg.appServiceToken;
      hs_token = cfg.homeserverToken;
      ephemeral_events = true;
    };

    bridge = {
      username_template = "discord_{{.}}";
      displayname_template = "{displayname}";
      displayname_preference = [ "name" "first_name" ];
      set_topic_on_dms = true;
      command_prefix = "!li";
      initial_chat_sync = 20;
      invite_own_puppet_to_pm = false;
      sync_with_custom_puppets = false;
      sync_direct_chat_list = true;
      space_support = {
        enable = true;
        name = "LinkedIn";
      };
      presence = false;
      update_avatar_initial_sync = true;
      login_shared_secret_map = {
        "nevarro.space" = removeSuffix "\n" (readFile synapseCfg.sharedSecretAuthFile);
      };
      federate_rooms = false;
      encryption = {
        allow = true;
        default = true;
        require = true;
        allow_key_sharing = true;
        verification_levels = {
          receive = "unverified";
          send = "cross-signed-tofu";
          share = "unverified";
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
        "@sumner:nevarro.space" = "admin";
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

  linkedinMatrixConfigYaml = yamlFormat.generate "linkedin-config.yaml" linkedinMatrixConfig;
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
    users.groups.linkedinmatrix = { };

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
      after = optional cfg.useLocalSynapse "matrix-synapse.target";
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
          static_configs = [{ targets = [ "0.0.0.0:9010" ]; }];
        }
      ];
    };
  };
}
