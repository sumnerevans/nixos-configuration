{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  networking.interfaces.eth0.useDHCP = true;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 2048;
    }
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/78831675-9f80-462b-b9fc-75a0efa368e5";
      fsType = "ext4";
    };
    "/mnt/syncthing-data" = {
      device = "/dev/disk/by-uuid/930c8bdb-7b71-4bdf-b478-6e85218cad37";
      fsType = "ext4";
    };
    "/mnt/syncthing-pictures-tmp" = {
      device = "/dev/disk/by-uuid/bfc8d39f-31e0-4261-9447-91bc7e39bb2f";
      fsType = "ext4";
    };
  };
}
