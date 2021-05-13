{ config, lib, pkgs, modulesPath, ... }: {
  # Set the hostname
  networking.hostName = "bespin";
  hardware.isServer = true;

  # Bootloader timeout to 10 seconds.
  boot.loader.timeout = 10;

  # Allow reboots when automatically upgrading.
  system.autoUpgrade.allowReboot = true;

  nix.gc.automatic = true;

  services.openssh.permitRootLogin = true;

  networking.interfaces.eth0.useDHCP = true;
}
