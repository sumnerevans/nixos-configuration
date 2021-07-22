{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.mx-puppet-slack;
  mx-puppet-slack = pkgs.callPackage ../../../pkgs/mx-puppet-slack {};
  yamlFormat = pkgs.formats.yaml {};

  mxPuppetSlackAppServiceConfig = {
    id = "slack-puppet";
    url = "http://${cfg.listenAddress}:${toString cfg.listenPort}";
    as_token = cfg.appServiceToken;
    hs_token = cfg.homeserverToken;
    rate_limited = false;
    sender_localpart = cfg.senderLocalpart;
    namespaces = {
      users = [ { regex = "@_slackpuppet_.*"; exclusive = true; } ];
      aliases = [ { regex = "#_slackpuppet_.*"; exclusive = true; } ];
      rooms = [];
    };
    "de.sorunome.msc2409.push_ephemeral" = true;
  };

  mxPuppetSlackAppServiceConfigYaml = pkgs.writeText "appservice.yaml" (
    generators.toYAML {} mxPuppetSlackAppServiceConfig
  );
  mxPuppetSlackConfig = pkgs.writeText "config.yaml" (
    generators.toYAML {} cfg.settings
  );
in
{
  options = {
    services.mx-puppet-slack = {
      enable = mkEnableOption "mx-puppet-slack, a Slack puppeting bridge for Matrix.";
      useLocalSynapse = mkOption {
        type = types.bool;
        default = true;
        description = "Whether or not to use the local synapse instance.";
      };
      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The address for heisenbridge to listen on.";
      };
      listenPort = mkOption {
        type = types.int;
        default = 8432;
        description = "The port for heisenbridge to listen on.";
      };
      settings = mkOption {
        type = types.submodule {
          freeformType = yamlFormat.type;
          options = {
            bridge = {
              bindAddress = mkOption {
                type = types.str;
                description = "The address for mx-puppet-slack to listen on.";
                default = "localhost";
              };
              port = mkOption {
                type = types.int;
                description = "The port for mx-puppet-slack to listen on.";
                default = cfg.listenPort;
              };
              domain = mkOption {
                type = types.str;
                description = "Public domain of the homeserver.";
              };
              homeserverUrl = mkOption {
                type = types.str;
                description = "Reachable URL of the Matrix homeserver";
              };
            };
            database = {
              filename = mkOption {
                type = types.path;
                description = "Path to the database file";
                default = "/var/lib/mxpuppetslack/database.db";
              };
            };
          };
        };
        default = {};
        description = "Configuration for mx-puppet-slack";
      };

      senderLocalpart = mkOption {
        type = types.str;
        default = "_slackpuppet_bot";
        description = "The localpart of the mx-puppet-slack admin bot's username.";
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
    assertions = [
      {
        assertion = cfg.useLocalSynapse -> config.services.matrix-synapse.enable;
        message = ''
          mx-puppet-slack must be running on the same server as Synapse if
          'useLocalSynapse' is enabled.
        '';
      }
    ];

    services.matrix-synapse.app_service_config_files = mkIf cfg.useLocalSynapse [
      mxPuppetSlackAppServiceConfigYaml
    ];

    # Create a user for mx-puppet-slack.
    users.users.mxpuppetslack = {
      group = "mxpuppetslack";
      isSystemUser = true;
    };
    users.groups.mxpuppetslack = {};

    systemd.services.mx-puppet-slack = {
      description = "mx-puppet-slack - Slack puppeting bridge for Matrix";
      after = optional cfg.useLocalSynapse "matrix-synapse.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${mx-puppet-slack}/bin/mx-puppet-slack \
            --registration-file ${mxPuppetSlackAppServiceConfigYaml} \
            --config ${mxPuppetSlackConfig}
        '';
        Restart = "on-failure";
      };
    };
  };
}
