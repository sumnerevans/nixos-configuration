{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
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
    wrapperFeatures = {
      # Fixes GTK applications under Sway
      gtk = true;

      # To make Sway run the extra session commands.
      base = true;
    };

    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
      export GTK_THEME="Arc-Dark"
      export MOZ_ENABLE_WAYLAND=1
    '';

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
