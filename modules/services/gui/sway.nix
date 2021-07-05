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
    nixpkgs.overlays =
      let
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

    # This is set when on Xorg, but for some reason not under sway.
    # The default max inotify watches is 8192.
    # Nowadays most apps require a good number of inotify watches,
    # the value below is used by default on several other distros.
    # See xserver.nix in nixpkgs.
    boot.kernel.sysctl."fs.inotify.max_user_instances" = mkDefault 524288;
    boot.kernel.sysctl."fs.inotify.max_user_watches" = mkDefault 524288;
  };
}
