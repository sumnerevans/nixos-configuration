{ config, lib, pkgs, modulesPath, ... }: {
  # Set the hostname
  networking.hostName = "coruscant";
  hardware.ramSize = 32;
  xorg.enable = true;
  xorg.xkbVariant = "3l";
}
