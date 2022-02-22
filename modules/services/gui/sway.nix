{ config, lib, pkgs, ... }: with lib; let
  cfg = config.wayland;

  rev = "master"; # 'rev' could be a git rev, to pin the overlay.
  url = "https://github.com/nix-community/nixpkgs-wayland/archive/${rev}.tar.gz";
  waylandOverlay = (import "${builtins.fetchTarball url}/overlay.nix");
in
{
  options.wayland = {
    enable = mkEnableOption "the wayland stack";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ waylandOverlay ];

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
      gtkUsePortal = true;
    };

    programs.sway.enable = true;
  };
}
