{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.heisenbridge;
  heisenbridge = pkgs.callPackage ../../../pkgs/heisenbridge.nix { };
  heisenbridgePython = pkgs.python3.withPackages (ps: with ps; [
    heisenbridge
  ]);
  heisenbridgeConfig = "${cfg.dataDir}/heisenbridge.yaml";
  heisenbridgeCmd = ''
    ${heisenbridgePython}/bin/python \
      -m heisenbridge \
      --config ${heisenbridgeConfig} \
      --verbose --verbose \
      --listen-address ${cfg.listenAddress} \
      --listen-port ${toString cfg.listenPort} \
      ${optionalString (cfg.ownerId != null) "--owner ${cfg.ownerId}"} \
      ${cfg.homeserver}'';
in
{
  options = {
    services.heisenbridge = {
      enable = mkEnableOption "heisenbridge, a bouncer-style Matrix IRC bridge.";
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
      ownerId = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The owner MXID (for example, @user:homeserver) of the bridge. If
          unspecified, the first talking local user will claim the bridge.
        '';
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/matrix-synapse";
        description = ''
          The directory where heisenbridge places the generated app service
          config file.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    meta.maintainers = [ maintainers.sumnerevans ];

    assertions = [{
      assertion = config.services.matrix-synapse.enable;
      message = "Heisenbridge must be running on the same server as Synapse.";
    }];

    services.matrix-synapse.app_service_config_files = [ heisenbridgeConfig ];

    systemd.services.heisenbridge-generate = {
      description = "Service to create the configuration for Heisenbridge.";
      before = [ "matrix-synapse.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "matrix-synapse";
        Group = "matrix-synapse";
        WorkingDirectory = cfg.dataDir;
        ExecStart = pkgs.writeShellScript "heisenbridge-create-config" ''
          if [[ -f ${heisenbridgeConfig} ]]; then
            exit 0
          else
            ${heisenbridgeCmd} --generate
          fi
        '';
      };
    };

    systemd.services.heisenbridge = {
      description = "Heisenbridge Matrix IRC bridge";
      after = [ "matrix-synapse.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "matrix-synapse";
        Group = "matrix-synapse";
        WorkingDirectory = cfg.dataDir;
        ExecStart = heisenbridgeCmd;
        ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
      };
    };
  };
}
