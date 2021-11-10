{ config, lib, pkgs, ... }: with lib; mkMerge [
  {
    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so this
    # generated config replicates the default behaviour.
    networking.useDHCP = false;
  }

  # If NetworkManager is enabled, then also enable strong swan integration.
  (
    mkIf config.networking.networkmanager.enable {
      networking.networkmanager.enableStrongSwan = true;
    }
  )

  (
    mkIf (!config.networking.networkmanager.enable) {
      networking.usePredictableInterfaceNames = false;

      services.unbound = {
        enable = true;
      };
    }
  )
]
