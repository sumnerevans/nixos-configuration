{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Set the hostname
  networking.hostName = "automattic";
  hardware.isPC = true;
  hardware.ramSize = 32;
  hardware.isLaptop = true;
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.thinkfan.enable = true;

  # Use systemd-boot
  boot = {
    loader.systemd-boot.enable = true;
    initrd = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Set up networking.
  networking.useDHCP = lib.mkDefault true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.sway.enable = true;
  programs.steam.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Extra options for btrfs
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e5c1f6c9-4417-4da6-9df9-ebc014050fed";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3A7A-964C";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32 * 1024;
  }];
}
