{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 32 * 1024;
    }
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/55764ade-c6c9-4a6d-abb4-3112148bd596";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/55764ade-c6c9-4a6d-abb4-3112148bd596";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/55764ade-c6c9-4a6d-abb4-3112148bd596";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };
    "/var/tmp" = {
      device = "/dev/disk/by-uuid/55764ade-c6c9-4a6d-abb4-3112148bd596";
      fsType = "btrfs";
      options = [
        "subvol=var/tmp"
        "compress=zstd"
        "noatime"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5BEB-2294";
      fsType = "vfat";
    };
  };
}
