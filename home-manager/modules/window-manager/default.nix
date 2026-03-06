{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  terminal = "${pkgs.kitty}/bin/kitty";
  xorgCfg = config.xorg;
in
{
  imports = [
    ./autorandr.nix
    ./i3status-rust.nix
    ./kanshi.nix
    ./kitty.nix
    ./mako.nix
    ./niri.nix
    ./rofi.nix
    ./wallpaper.nix
    ./sway.nix
    ./swaylock.nix
    ./wayland.nix
    ./writeping.nix
    ./xorg.nix
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
      home.sessionVariables = {
        TERMINAL = "${terminal}";
      };

      home.pointerCursor = {
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-light";
        size = 32;

        gtk.enable = true;
      };

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.arc-icon-theme;
          name = "Arc";
        };

        theme = {
          package = pkgs.arc-theme;
          name = "Arc-Dark";
        };

        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        };

        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk";
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
