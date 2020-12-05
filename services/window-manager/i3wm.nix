{ config, pkgs, ... }: let
  isMustafar = config.networking.hostName == "mustafar";
in
{
  environment.systemPackages = with pkgs; [
    dunst
    flameshot
    lxappearance
    scrot
    xbindkeys
    xclip
    xorg.xbacklight
    xorg.xdpyinfo
    xorg.xprop
  ];

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    displayManager.startx.enable = true;

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
}
