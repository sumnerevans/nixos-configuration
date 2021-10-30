{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.heisenbridge;
  heisenbridge = pkgs.callPackage ../../../pkgs/heisenbridge.nix { };

  heisenbridgeAppserviceConfig = {
    id = "heisenbridge";
    url = "http://${cfg.listenAddress}:${toString cfg.listenPort}";
    as_token = cfg.appServiceToken;
    hs_token = cfg.homeserverToken;
    rate_limited = false;
    sender_localpart = cfg.senderLocalpart;
    namespaces = {
      users = [{ regex = "@irc_.*"; exclusive = true; }];
      aliases = [ ];
      rooms = [ ];
    };
  };

  yamlFormat = pkgs.formats.yaml { };
  heisenbridgeConfigYaml = yamlFormat.generate "heisenbridge.yaml" heisenbridgeAppserviceConfig;
in
{
  options = {
    services.heisenbridge = {
      enable = mkEnableOption "heisenbridge, a bouncer-style Matrix IRC bridge.";
      identd.enable = mkEnableOption "identd for heisenbridge" // {
        default = true;
      };
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
        description = "The address for heisenbridge to listen on.";
      };
      listenPort = mkOption {
        type = types.int;
        default = 9898;
        description = "The port for heisenbridge to listen on.";
      };
      senderLocalpart = mkOption {
        type = types.str;
        default = "heisenbridge";
        description = "The localpart of the heisenbridge admin bot's username.";
      };
      ownerId = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The owner MXID (for example, @user:homeserver) of the bridge. If
          unspecified, the first talking local user will claim the bridge.
        '';
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

    assertions = [{
      assertion = cfg.useLocalSynapse -> config.services.matrix-synapse-custom.enable;
      message = ''
        Heisenbridge must be running on the same server as Synapse if
        'useLocalSynapse' is enabled.
      '';
    }];

    services.matrix-synapse-custom.appServiceConfigFiles = mkIf cfg.useLocalSynapse [
      heisenbridgeConfigYaml
    ];

    # Create a user for heisenbridge.
    users.users.heisenbridge = {
      group = "heisenbridge";
      isSystemUser = true;
    };
    users.groups.heisenbridge = { };

    # Open ports for identd.
    networking.firewall.allowedTCPPorts = mkIf cfg.identd.enable [ 113 ];

    systemd.services.heisenbridge = {
      description = "Heisenbridge Matrix IRC bridge";
      after = optional cfg.useLocalSynapse "matrix-synapse.target";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${heisenbridge}/bin/heisenbridge \
            --config ${heisenbridgeConfigYaml} \
            --verbose --verbose \
            --listen-address ${cfg.listenAddress} \
            --listen-port ${toString cfg.listenPort} \
            --uid heisenbridge \
            --gid heisenbridge \
            ${optionalString cfg.identd.enable "--identd"} \
            ${optionalString (cfg.ownerId != null) "--owner ${cfg.ownerId}"} \
            ${cfg.homeserver}
        '';
        Restart = "on-failure";
      };
    };
  };
}
