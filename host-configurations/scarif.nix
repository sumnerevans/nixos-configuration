{
  # Set the hostname
  networking.hostName = "scarif";
  hardware.isPC = true;
  hardware.ramSize = 32;
  hardware.isLaptop = true;

  wayland.enable = true;
  programs.steam.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/var/tmp".options = [ "compress=zstd" "noatime" ];
  };
}
