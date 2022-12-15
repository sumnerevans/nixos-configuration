{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.mautrix-discord;
  synapseCfg = config.services.matrix-synapse-custom;

  mautrix-discord = pkgs.callPackage ../../../pkgs/mautrix-discord { };

  mautrixDiscordAppserviceConfig = {
    id = "discord";
    url = "http://${cfg.listenAddress}:${toString cfg.listenPort}";
    as_token = cfg.appServiceToken;
    hs_token = cfg.homeserverToken;
    rate_limited = false;
    sender_localpart = "LI6W2mH43X68rSiZ1YLAQCSLtuSZlPBt";
    "de.sorunome.msc2409.push_ephemeral" = true;
    push_ephemeral = true;
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
      database = {
        type = "sqlite3-fk-wal";
        uri = "file:${cfg.dataDir}/mautrix-discord.db?_txlock=immediate";
        max_open_conns = 20;
        max_idle_cons = 2;
      };
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
      displayname_template = "{{.Username}}#{{.Discriminator}} (D){{if .Bot}} (bot){{end}}";
      channel_name_template = "{{if or (eq .Type 3) (eq .Type 4)}}{{.Name}}{{else}}#{{.Name}}{{end}}";
      guild_name_template = "{{.Name}}";
      private_chat_portal_meta = false;
      portal_message_buffer = 128;
      startup_private_channel_create_limit = 5;
      delivery_receipts = true;
      message_error_notices = true;
      restricted_rooms = true;
      delete_portal_on_channel_delete = true;
      federate_rooms = false;
      login_shared_secret_map = {
        "nevarro.space" = removeSuffix "\n" (readFile synapseCfg.sharedSecretAuthFile);
      };
      command_prefix = "!dis";
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
      permissions = {
        "nevarro.space" = "user";
        "@sumner:sumnerevans.com" = "admin";
        "@sumner:nevarro.space" = "admin";
      };
    };

    logging = {
      directory = "./logs";
      file_name_format = "{{.Date}}-{{.Index}}.log";
      file_date_format = "2006-01-02";
      file_mode = 384;
      timestamp_format = "Jan _2, 2006 15:04:05";
      print_level = "debug";
      print_json = false;
      file_json = false;
    };
  };

  mautrixDiscordConfigYaml = yamlFormat.generate "mautrix-discord-config.yaml" mautrixDiscordConfig;
in
{
  options = {
    services.mautrix-discord = {
      enable = mkEnableOption "mautrix-discord, a Discord <-> Matrix bridge.";
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
        description = "The address for mautrix-discord to listen on.";
      };
      listenPort = mkOption {
        type = types.int;
        default = 9890;
        description = "The port for mautrix-discord to listen on.";
      };
      botUsername = mkOption {
        type = types.str;
        default = "discordbot";
        description = "The localpart of the mautrix-discord admin bot's username.";
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
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/mautrix-discord";
      };
    };
  };

  config = mkIf cfg.enable {
    meta.maintainers = [ maintainers.sumnerevans ];

    assertions = [
      {
        assertion = cfg.useLocalSynapse -> config.services.matrix-synapse-custom.enable;
        message = ''
          Mautrix-Discord must be running on the same server as Synapse if
          'useLocalSynapse' is enabled.
        '';
      }
    ];

    services.matrix-synapse-custom.appServiceConfigFiles = mkIf cfg.useLocalSynapse [
      mautrixDiscordAppserviceConfigYaml
    ];

    # Create a user for mautrix-discord.
    users = {
      users.mautrixdiscord = {
        group = "mautrixdiscord";
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
      groups.mautrixdiscord = { };
    };

    systemd.services.mautrix-discord = {
      description = "Discord <-> Matrix Bridge";
      after = optional cfg.useLocalSynapse "matrix-synapse.target";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir}/logs
      '';
      serviceConfig = {
        User = "mautrixdiscord";
        Group = "mautrixdiscord";
        ExecStart = ''
          ${mautrix-discord}/bin/mautrix-discord \
            --config ${mautrixDiscordConfigYaml} \
            --no-update
        '';
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
      };
    };

    services.prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "mautrixdiscord";
          scrape_interval = "15s";
          metrics_path = "/";
          static_configs = [{ targets = [ "0.0.0.0:9011" ]; }];
        }
      ];
    };
  };
}
