{ pkgs, ... }: let
  rev = "master";
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/${rev}.tar.gz";
  waylandOverlay = (import (builtins.fetchTarball url));
  sway-accel-rotate = pkgs.callPackage ../../pkgs/sway-accel-rotate.nix {};
in
{
  environment.variables = {
    GTK_THEME = "Arc-Dark";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };

  nixpkgs.overlays = [ waylandOverlay ];

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
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      clipman
      glib # for GTK settings
      grim
      mako # notification daemon
      slurp
      sway-accel-rotate # auto screen rotate
      swaylock-effects # lockscreen
      v4l-utils
      wf-recorder
      wl-clipboard # clipboard management
      wofi
      xdg_utils
      xwayland # for legacy apps
    ];
  };
}
