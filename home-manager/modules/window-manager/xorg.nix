{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.xorg;
  common = import ./common.nix { inherit config lib pkgs; };
  fuzzy-lock = import ./fuzzy-lock.nix { inherit config lib pkgs; };

  modifier = config.windowManager.modKey;
  tmpdir = "${config.home.homeDirectory}/tmp";
  mvTmp = "${pkgs.coreutils}/bin/mv $f ${tmpdir}";
  scrotCmd = "${pkgs.scrot}/bin/scrot '%Y-%m-%d-%T.png'";
in
{
  options.xorg = {
    enable = mkEnableOption "the Xorg stack";
    extrai3wmConfig = mkOption {
      type = types.attrsOf types.anything;
      description = "Extra config for i3wm";
      default = { };
    };
    remapEscToCaps = mkOption {
      type = types.bool;
      description = "Remap the physical escape key to Caps Lock.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    dconf.enable = false;
    xsession = {
      enable = true;

      windowManager.i3 = mkMerge [
        common.i3SwayConfig
        {
          config.startup = [
            {
              command = "${pkgs.autorandr}/bin/autorandr --change";
              always = true;
            }
          ];

          config.keybindings = {
            # Popup Clipboard Manager
            "${modifier}+c" = "exec ${pkgs.clipmenu}/bin/clipmenu";

            # Lock screen
            "${modifier}+Shift+x" = "exec ${fuzzy-lock}/bin/fuzzy-lock";

            # exit i3wm (logs you out of your session)
            "${modifier}+Shift+e" =
              ''exec "${pkgs.i3-gaps}/bin/i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"'';

            # Screenshots
            "${modifier}+shift+ctrl+c" = ''exec "${scrotCmd} -e '${mvTmp}'"'';
            "${modifier}+shift+c" = ''exec "${pkgs.flameshot}/bin/flameshot gui -p ${tmpdir}"'';
            "${modifier}+shift+f" = ''exec "${pkgs.flameshot}/bin/flameshot gui -p ${tmpdir}"'';
            Print = ''exec "${scrotCmd} -e '${mvTmp}'"'';
          };
        }
        cfg.extrai3wmConfig
      ];

      profileExtra = ''
        systemctl --user import-environment
      '';
    };

    xresources.extraConfig = ''
      Xft.dpi: 100
    '';

    home.pointerCursor.x11.enable = true;

    services.clipmenu.enable = true;
    home.sessionVariables = {
      CM_HISTLENGTH = "20";
      CM_LAUNCHER = "rofi";
    };

    home.packages = with pkgs; [
      flameshot
      i3lock
      lxappearance
      scrot
      xclip
      xorg.xbacklight
      xorg.xdpyinfo
      xorg.xprop
    ];

    services.redshift = common.redshiftGammastepCfg;

    services.dunst = {
      enable = true;
      iconTheme = {
        name = "hicolor";
        package = pkgs.paper-icon-theme;
        size = "32x32";
      };
      settings = {
        global = {
          follow = "none";
          corner_radius = 5;
          frame_color = "#8EC07C";
          width = 350;
          height = 200;
          notification_height = 50;
          offset = "15x36";
          horizontal_padding = 6;
          notification_limit = 11;
          indicate_hidden = true;
          idle_threshold = 30;
          markup = true;
          padding = 6;
          show_age_threshold = 20;
          show_indicators = false;
          transparency = 10;
          word_wrap = true;

          # Text
          font = "Iosevka 10";
          format = "<b>%s</b>\\n%b\\n%p";
          line_height = 3;
        };
      }
      // common.notificationColorConfig;
    };

    services.picom = {
      enable = true;
      vSync = true;

      fade = true;
      fadeDelta = 5;

      inactiveOpacity = 0.8;
      opacityRules = [
        "100:class_g *= 'obs'"
        "100:class_g *= 'i3lock'"
        "100:class_g ?= 'rofi'"
      ];

      shadow = true;
      shadowExclude = [
        "name = 'Notification'"
        "class_g = 'Conky'"
        "class_g ?= 'Notify-osd'"
        "class_g = 'Cairo-clock'"
        "class_g = 'i3-frame'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
    };

    systemd.user.services =
      let
        xmodmapConfig = pkgs.writeText "Xmodmap.conf" ''
          ! Reverse scrolling
          ! pointer = 1 2 3 5 4 6 7 8 9 10 11 12
          keycode 9 = Caps_Lock Caps_Lock Caps_Lock
        '';
        startupServices = {
          xbanish = "${pkgs.xbanish}/bin/xbanish";
        }
        // (optionalAttrs cfg.remapEscToCaps {
          xmodmap = "${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmapConfig}";
        });
      in
      mapAttrs (name: value: {
        Unit = {
          Description = "Run ${name} on startup.";
          PartOf = [ "graphical-session.target" ];
        };
        Service.ExecStart = value;
        Service.Restart = "always";
        Install.WantedBy = [ "graphical-session.target" ];
      }) startupServices;
  };
}
