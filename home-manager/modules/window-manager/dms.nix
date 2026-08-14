{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options = {
    dms.enable = lib.mkEnableOption "Dank Material Shell";
  };

  imports = [
    inputs.dms-plugin-registry.nixosModules.default
    inputs.dms.homeModules.dank-material-shell
    inputs.dcal.homeModules.dank-calendar
  ];

  config = lib.mkIf config.dms.enable {
    programs.dank-calendar.enable = true;

    programs.dank-material-shell = {
      enable = true;

      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
      enableClipboardPaste = true; # Pasting items from the clipboard (wtype)

      settings = import ./dms-settings.nix;

      clipboardSettings = {
        maxHistory = 1000;
        maxEntrySize = 5242880;
        autoClearDays = 0;
        clearAtStartup = false;
        disabled = false;
        maxPinned = 25;
      };

      plugins = {
        offlinemsmtp = {
          enable = true;
          src = ./dms-plugins/offlinemsmtp;
        };
        calculator = {
          enable = true;
          settings.trigger = "=";
        };
        dankBatteryAlerts.enable = true;
        dmsScreenshot = {
          enable = true;
          settings = {
            customPath = "${config.home.homeDirectory}/tmp";
            filename = "screenshot-%Y-%m-%d_%H%M%S.png";
          };
        };
        screenRecorder.enable = true;
        webSearch = {
          enable = true;
          settings = {
            disabledEngines = [
              "brave"
              "bing"
              "kagi"
              "ebay"
              "archlinux"
              "aur"
              "crates"
            ];
            defaultEngine = "duckduckgo";
          };
        };
        worldClock = {
          enable = true;
          settings = {
            timezones = [
              {
                label = "UTC";
                timezone = "UTC";
              }
            ];
          };
        };
      };
    };

    # DMS syncs its dark/light mode to the freedesktop Settings portal by
    # shelling out to `gsettings set org.gnome.desktop.interface
    # color-scheme ...` (see Services/PortalService.qml). Because of
    # https://github.com/nix-community/home-manager/issues/5542, systemd
    # user services don't reliably see home-manager's session-wide
    # XDG_DATA_DIRS additions, so that call silently fails to find the
    # org.gnome.desktop.interface schema and the dconf key never gets
    # written. Set GSETTINGS_SCHEMA_DIR directly on the unit so it doesn't
    # depend on that.
    systemd.user.services.dms.Service.Environment = [
      "GSETTINGS_SCHEMA_DIR=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas"
    ];
  };
}
