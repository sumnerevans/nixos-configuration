{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.niri;
in
{
  options = {
    niri.enable = lib.mkEnableOption "Niri WM";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      niri
      xwayland-satellite
    ];
    xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;

    programs.fuzzel.enable = true;
    services.polkit-gnome.enable = true;

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
    };

    xdg.portal.config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };
}
