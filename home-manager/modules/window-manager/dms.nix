{
  config,
  inputs,
  lib,
  ...
}:
{
  options = {
    dms.enable = lib.mkEnableOption "Dank Material Shell";
  };

  imports = [
    inputs.dms-plugin-registry.nixosModules.default
    inputs.dms.homeModules.dank-material-shell
  ];

  config = lib.mkIf config.dms.enable {
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
  };
}
