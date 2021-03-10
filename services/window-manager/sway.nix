{ config, lib, pkgs, ... }: with lib; let
  cfg = config.wayland;
in
{
  options = {
    wayland.enable = mkOption {
      type = types.bool;
      description = "Enable the wayland stack";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = let
      rev = "master";
      url = "https://github.com/colemickens/nixpkgs-wayland/archive/${rev}.tar.gz";
      waylandOverlay = (import (builtins.fetchTarball url));
    in
      [ waylandOverlay ];

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
        swaylock-effects # lockscreen
        v4l-utils
        wf-recorder
        wl-clipboard # clipboard management
        wofi
        xdg_utils
        xwayland # for legacy apps
      ];
    };
  };
}
