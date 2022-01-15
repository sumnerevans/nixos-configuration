{
  # Set the hostname
  networking.hostName = "jedha";
  hardware.isPC = true;
  hardware.ramSize = 32;
  hardware.isLaptop = true;

  nix.enableRemoteBuildOnCoruscant = true;
  nix.enableRemoteBuildOnTatooine = true;

  # Enable bumblebee.
  # hardware.bumblebee.enable = true;

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  wayland.enable = true;
  # xorg.enable = true;
  # xorg.xkbVariant = "3l";

  programs.steam.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;
}
