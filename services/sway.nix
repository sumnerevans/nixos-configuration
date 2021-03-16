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

    programs.sway.enable = true;
  };
}
