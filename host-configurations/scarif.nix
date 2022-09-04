{ pkgs, ... }: {
  # Set the hostname
  networking.hostName = "scarif";
  hardware.isPC = true;
  hardware.ramSize = 32;
  hardware.isLaptop = true;

  services.thinkfan.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set up networking.
  networking.interfaces.wlp1s0.useDHCP = true;

  wayland.enable = true;
  programs.steam.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;

  # Extra options for btrfs
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/var/tmp".options = [ "compress=zstd" "noatime" ];
  };
}
