{ modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Set the hostname
  networking.hostName = "coruscant";
  hardware.isPC = true;
  hardware.ramSize = 32;

  programs.sway.enable = true;

  programs.steam.enable = true;

  networking.interfaces.enp37s0.useDHCP = true;
  networking.interfaces.wlp35s0.useDHCP = true;

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable mosh and et
  programs.mosh.enable = true;
  services.eternal-terminal.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/800c39b4-cfb3-439e-b98e-5bdead667b59";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FF0A-976B";
    fsType = "vfat";
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/ae393747-6e8f-4d21-863f-ee92fa79d972";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/2c465006-522b-4668-9de4-a40dafc76a64"; }];
}
