{ config, lib, pkgs, modulesPath, ... }: {
  # Set the hostname
  networking.hostName = "coruscant";
  hardware.ramSize = 32;
  xorg.enable = true;
  xorg.remapEscToCaps = false;

  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp35s0.useDHCP = true;

  services.xserver.videoDrivers = [ "nvidia" ];
}
