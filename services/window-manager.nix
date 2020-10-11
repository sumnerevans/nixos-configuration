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

  services.xbanish.enable = true;

  # Add some environment variables for when things get fired up with shortcuts
  # in i3.
  environment.variables = {
    VISUAL = "${editor}";
    EDITOR = "${editor}";
    TERMINAL = "${terminal}";
  };

  systemd.user.services.xmodmap = let
    xmodmapConfig = pkgs.writeText "Xmodmap.conf" ''
      ! Reverse scrolling
      ! pointer = 1 2 3 5 4 6 7 8 9 10 11 12
      keycode 9 = Caps_Lock Caps_Lock Caps_Lock
    '';
  in {
    description = "Run xmodmap on startup.";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmapConfig}";
  };

  systemd.user.services.xbindkeys = {
    description = "Run xbindkeys on startup.";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys";
  };

  # Enable the Network Manager applet
  programs.nm-applet.enable = true;
  systemd.user.services.nm-applet.serviceConfig = {
    Restart = "always";
    RestartSec = 5;
  };
}
