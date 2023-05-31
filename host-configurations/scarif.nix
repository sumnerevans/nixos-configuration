{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Set the hostname
  networking.hostName = "scarif";
  hardware.isPC = true;
  hardware.ramSize = 32;
  hardware.isLaptop = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.thinkfan.enable = true;

  # Use systemd-boot
  boot = {
    loader.systemd-boot.enable = true;
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Fingerprint reader
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };
  security.pam.services = {
    # The fingerprint auth doesn't work correctly after waking from sleep
    swaylock.fprintAuth = false;
  };
  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll") {
        return subject.user == "sumner" || subject.user == "root" ? polkit.Result.YES : polkit.Result.NO
      }
    })
  '';

  # Set up networking.
  networking.interfaces.wlp1s0.useDHCP = true;
  networking.useDHCP = lib.mkDefault true;

  programs.sway.enable = true;
  programs.steam.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Extra options for btrfs
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/55764ade-c6c9-4a6d-abb4-3112148bd596";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/55764ade-c6c9-4a6d-abb4-3112148bd596";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/55764ade-c6c9-4a6d-abb4-3112148bd596";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
    "/var/tmp" = {
      device = "/dev/disk/by-uuid/55764ade-c6c9-4a6d-abb4-3112148bd596";
      fsType = "btrfs";
      options = [ "subvol=var/tmp" "compress=zstd" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/5BEB-2294";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];
}
