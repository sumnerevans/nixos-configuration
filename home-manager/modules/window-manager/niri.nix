{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.niri;
in
{
  options = {
    niri.enable = mkEnableOption "Niri WM";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      niri
      swaybg
      dms-shell
      xwayland-satellite
    ];
    xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;

    # TODO extract to separate file?
    programs.fuzzel = {
      enable = true;
    };

    services.polkit-gnome.enable = true; # polkit

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
    };

    xdg.portal.config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };
}
