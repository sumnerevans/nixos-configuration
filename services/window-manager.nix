{ config, pkgs, ... }: let
  editor = "nvim";
  terminal = "alacritty";
in
{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Use 3l
    layout = "us";
    xkbVariant = "3l";

    # Enable touchpad support.
    libinput = {
      enable = true;
      tapping = false;
    };

    # Enable i3
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };
  };

  # Add some environment variables
  environment.variables = {
    VISUAL = "${editor}";
    EDITOR = "${editor}";
    TERMINAL = "${terminal}";
  };
}
