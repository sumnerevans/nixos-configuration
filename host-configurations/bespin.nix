{ config, lib, pkgs, modulesPath, ... }: {
  # Set the hostname
  networking.hostName = "bespin";
  networking.domain = "sumnerevans.com";
  hardware.isServer = true;

  # Bootloader timeout to 10 seconds.
  boot.loader.timeout = 10;

  # Allow reboots when automatically upgrading.
  system.autoUpgrade.allowReboot = true;

  nix.gc.automatic = true;

  services.openssh.permitRootLogin = true;

  networking.interfaces.eth0.useDHCP = true;

  # Enable a lot of swap since we have enough disk. This way, if Airsonic eats
  # memory, it won't crash the box.
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];
}
