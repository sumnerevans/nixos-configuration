{ config, pkgs, ... }: let
  editor = "nvim";
  terminal = "alacritty";
  isMustafar = config.networking.hostName == "mustafar";
in
{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Use 3l
    layout = "us";
    xkbVariant = if isMustafar then "3l-cros" else "3l";

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
  } // (
    if isMustafar then {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    } else {}
  );

  systemd.user.services.xmodmap = let
    xmodmapConfig = pkgs.writeText "Xmodmap.conf" ''
      ! Reverse scrolling
      ! pointer = 1 2 3 5 4 6 7 8 9 10 11 12
      keycode 9 = Caps_Lock Caps_Lock Caps_Lock
    '';
  in
    {
      description = "Run xmodmap on startup.";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = "${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmapConfig}";
    };

  # Enable the Network Manager applet
  programs.nm-applet.enable = true;
  systemd.user.services.nm-applet.serviceConfig = {
    Restart = "always";
    RestartSec = 5;
  };
}
