{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.programs.sway.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
