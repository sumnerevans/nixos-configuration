{ config, lib, pkgs, ... }: {
  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so this
    # generated config replicates the default behaviour.
    useDHCP = false;

    # Only use predictable interface names if using NetworkManager.
    usePredictableInterfaceNames = config.networking.networkmanager.enable;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Enable tailscale across the fleet
  environment.systemPackages = [ pkgs.tailscale ];
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = true;
  };
}
