{ config, lib, pkgs, modulesPath, ... }: {
  # Set the hostname
  networking.hostName = "coruscant";
  hardware.isPC = true;
  hardware.ramSize = 32;
  xorg.enable = true;

  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp35s0.useDHCP = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
