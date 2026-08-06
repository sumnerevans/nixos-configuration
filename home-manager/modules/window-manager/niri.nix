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

    services.polkit-gnome.enable = true;

    xdg = {
      configFile = {
        "niri/config.kdl".source = ./niri-config.kdl;
        # gnome portal must start after niri registers org.gnome.Mutter.ScreenCast on D-Bus
        "systemd/user/xdg-desktop-portal-gnome.service.d/niri.conf".text = ''
          [Unit]
          After=niri.service
        '';
      };
      portal = {
        configPackages = with pkgs; [
          niri
        ];
        config.niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        };
      };
    };
  };
}
