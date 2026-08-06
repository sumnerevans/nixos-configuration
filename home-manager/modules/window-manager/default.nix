{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    ./dms.nix
    ./hyprland.nix
    ./kitty.nix
    ./niri.nix
    ./wayland.nix
  ];

  options = {
    windowManager.modKey = mkOption {
      type = types.enum [
        "Shift"
        "Control"
        "Mod1"
        "Mod2"
        "Mod3"
        "Mod4"
        "Mod5"
      ];
      default = "Mod4";
      description = "Modifier key that is used for all default keybindings.";
    };
  };

  config = mkMerge [
    {
      home.packages = with pkgs; [
        xdg-desktop-portal-gtk
        gsettings-desktop-schemas
      ];

      home.sessionVariables = {
        TERMINAL = "${pkgs.kitty}/bin/kitty";
      };

      home.pointerCursor = {
        enable = true;
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-light";
        size = 32;

        gtk.enable = true;
      };

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus-Dark";
        };

        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
        gtk3.extraCss = ''
          @import url("dank-colors.css");
        '';

        gtk4.theme = config.gtk.theme;
        gtk4.extraCss = ''
          @import url("dank-colors.css");
        '';
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk3";
      };
    }
    (mkIf config.wayland.windowManager.sway.enable {
      home.packages = with pkgs; [
        brightnessctl
        menucalc
        wmctrl
      ];

      # Enable GUI services
      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    })
  ];
}
