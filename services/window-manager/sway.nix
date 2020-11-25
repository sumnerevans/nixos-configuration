{ pkgs, ... }:
{
  environment.variables = {
    GTK_THEME = "Arc-Dark";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
    gtkUsePortal = true;
  };

  # Make sway the graphical-session target.
  systemd.user.targets.sway-session = {
    description = "sway window manager session";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      clipman
      glib # for GTK settings
      gnome3.networkmanagerapplet
      grim
      mako # notification daemon
      slurp
      swaylock-effects # lockscreen
      v4l-utils
      waybar # status bar
      wf-recorder
      wl-clipboard # clipboard management
      wofi
      xdg_utils
      xwayland # for legacy apps
    ];
  };
}
