{ pkgs, ... }: {
  # Set the hostname
  networking.hostName = "scarif";
  hardware.isPC = true;
  hardware.ramSize = 32;
  hardware.isLaptop = true;

  services.thinkfan.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Fingerprint reader
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
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
