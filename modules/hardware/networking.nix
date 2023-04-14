{ config, lib, pkgs, ... }: with lib; mkMerge [
  {
    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so this
    # generated config replicates the default behaviour.
    networking.useDHCP = false;

    # Enable tailscale across the fleet
    services.tailscale.enable = true;
    networking = {
      firewall.allowedUDPPorts = [ config.services.tailscale.port ];

      # NixOS is kinda particular about how you configure the Magic DNS, so we have to do it a bit more manually. See: https://forum.tailscale.com/t/magicdns-nixos/412
      nameservers = [ "100.100.100.100" ];
      search = [ "sumnerevans.github.beta.tailscale.net" ];
    };
    environment.systemPackages = [ pkgs.tailscale ];
  }

  (
    mkIf (!config.networking.networkmanager.enable) {
      networking.usePredictableInterfaceNames = false;

      services.unbound = {
        enable = true;
      };
    }
  )
]
