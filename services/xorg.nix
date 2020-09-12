{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "3l";

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    tapping = false;
  };

  # Enable i3
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  };
}
