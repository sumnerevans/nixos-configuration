{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = lib.removeSuffix "\n" (builtins.readFile "/etc/nixos/hostname");
    networkmanager = {
      enable = true;
      enableStrongSwan = true;
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;
  };
}
