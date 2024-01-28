{ lib, ... }: {
  # Set the hostname
  networking.hostName = "mustafar";
  hardware.isPC = true;
  hardware.ramSize = 8;
  hardware.isLaptop = true;
  programs.sway.enable = true;

  virtualisation.docker.enable = true;

  # Get sound working
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # Orientation and ambient light
  hardware.sensor.iio.enable = true;

  # Set up networking.
  networking.interfaces.wlp0s20f3.useDHCP = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/84c203a4-3277-4884-8f22-b49187480eb9";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CFB2-2BBA";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
