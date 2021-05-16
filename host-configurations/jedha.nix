{
  # Set the hostname
  networking.hostName = "jedha";
  hardware.isPC = true;
  hardware.ramSize = 32;
  hardware.isLaptop = true;

  # Enable bumblebee.
  hardware.bumblebee.enable = true;

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  xorg.enable = true;
  xorg.xkbVariant = "3l";

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;
}
