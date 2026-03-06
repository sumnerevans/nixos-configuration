{
  config,
  lib,
  pkgs,
}:
with lib;
{
  redshiftGammastepCfg = {
    enable = true;
    provider = "geoclue2";
    tray = true;

    temperature = {
      day = 5500;
      night = 4000;
    };
  };

  notificationColorConfig = {
    urgency_low = {
      frame_color = "#777777";
      foreground = "#777777";
      background = "#191311";
      timeout = 4;
    };

    urgency_normal = {
      frame_color = "#5B8234";
      foreground = "#5B8234";
      background = "#191311";
      timeout = 8;
    };

    urgency_critical = {
      frame_color = "#B7472A";
      foreground = "#B7472A";
      background = "#191311";
      timeout = 12;
    };
  };

  i3SwayConfig =
    let
      resizeStr = "  ";
      gapSize = 6;
      workspaces = [
        "1: "
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "10"
      ];
      extraWorkspaces = [
        {
          name = "11: ";
          keycode = 20;
        }
        {
          name = "12: ";
          keycode = 21;
        }
      ];

      left = "h";
      down = "j";
      up = "k";
      right = "l";
      fonts = {
        names = [
          "FontAwesome"
          "Iosevka"
        ];
        size = 10.0;
      };
    in
    {
      config = rec {
        inherit fonts;
        gaps.inner = gapSize;
        modifier = config.windowManager.modKey;
        terminal = config.home.sessionVariables.TERMINAL;

        assigns = {
          # Browsers
          ${elemAt workspaces 0} = [ { class = "Firefox"; } ];

          # Chat Clients
          ${(elemAt extraWorkspaces 0).name} = [
            { class = "discord"; }
            { class = "Element"; }
            { title = "Mutt"; }
          ];
        };

        bars = [
          {
            inherit fonts;
            position = "top";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.xdg.configHome}/i3status-rust/config-top.toml";
            colors = {
              background = "#00000090";
              separator = "#aaaaaa";
            };
          }
        ];

        floating.criteria = [
          { instance = "pinentry"; }
          { title = "Firefox - Sharing Indicator"; }
          { class = "zoom"; }
        ];

        defaultWorkspace = ''workspace "${elemAt workspaces 0}"'';

        keybindings =
          listToAttrs (
            # Switch to workspace
            (imap1 (i: name: {
              name = "${modifier}+${toString (mod i 10)}";
              value = ''workspace "${name}"'';
            }) workspaces)
            # Move to workspace
            ++ (imap1 (i: name: {
              name = "${modifier}+Shift+${toString (mod i 10)}";
              value = ''move container to workspace "${name}"'';
            }) workspaces)
          )
          // {
            "${modifier}+Return" = "exec ${terminal}";
            "${modifier}+Shift+q" = "kill";

            # RESTART SWAY IN-PLACE (PRESERVES YOUR LAYOUT/SESSION, CAN BE USED TO UPGRADE SWAY)
            "${modifier}+Shift+R" = "reload";

            # LAUNCHERS
            "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show run";
            "${modifier}+space" = "exec ${pkgs.rofi}/bin/rofi -show drun -show-icons";
            "${modifier}+F4" = "exec ${pkgs.menucalc}/bin/= -- -lines 3"; # menu-calc

            # FOCUS
            "${modifier}+${left}" = "focus left";
            "${modifier}+${down}" = "focus down";
            "${modifier}+${up}" = "focus up";
            "${modifier}+${right}" = "focus right";

            # MOVEMENT
            "${modifier}+Shift+${left}" = "move left";
            "${modifier}+Shift+${down}" = "move down";
            "${modifier}+Shift+${up}" = "move up";
            "${modifier}+Shift+${right}" = "move right";

            # WORKSPACE MOVEMENT
            "${modifier}+greater" = "move workspace to output right";
            "${modifier}+less" = "move workspace to output left";

            # SPLIT IN HORIZONTAL/VERTICAL ORIENTATION
            "${modifier}+semicolon" = "split h";
            "${modifier}+v" = "split v";

            # CHANGE CONTAINER LAYOUT (STACKED, TABBED, TOGGLE SPLIT)
            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            # ENTER FULLSCREEN MODE FOR THE FOCUSED CONTAINER
            "${modifier}+f" = "fullscreen toggle";

            # TOGGLE TILING / FLOATING
            button2 = "floating toggle";
            "${modifier}+Shift+space" = "floating toggle";

            # FOCUS THE PARENT CONTAINER
            "${modifier}+a" = "focus parent";

            # RESIZE
            "${modifier}+r" = ''mode "${resizeStr}"'';

            # GAPS
            "${modifier}+F3" = "gaps inner all set 0";
            "${modifier}+Shift+F3" = "gaps inner all set ${toString gapSize}";

            # VOLUME KEYS
            XF86AudioLowerVolume = "exec ${pkgs.pamixer}/bin/pamixer --decrease 2";
            XF86AudioRaiseVolume = "exec ${pkgs.pamixer}/bin/pamixer --increase 2";
            XF86AudioMute = "exec ${pkgs.pamixer}/bin/pamixer --toggle-mute";

            # MEDIA CONTROLS
            XF86AudioPrev = "exec playerctl previous";
            XF86AudioPlay = "exec playerctl play-pause";
            XF86AudioStop = "exec playerctl stop";
            XF86AudioNext = "exec playerctl next";

            # SCREEN BRIGHTNESS CONTROLS
            XF86MonBrightnessDown = mkIf config.laptop.enable "exec brightnessctl s 5%-";
            XF86MonBrightnessUp = mkIf config.laptop.enable "exec brightnessctl s +5%";
          };

        keycodebindings =
          listToAttrs (
            # Switch to workspace
            (imap1 (
              i:
              { name, keycode }:
              {
                name = "${modifier}+${toString keycode}";
                value = ''workspace "${name}"'';
              }
            ) extraWorkspaces)
            # Move to workspace
            ++ (imap1 (
              i:
              { name, keycode }:
              {
                name = "${modifier}+Shift+${toString keycode}";
                value = ''move container to workspace "${name}"'';
              }
            ) extraWorkspaces)
          )
          // {
            "${modifier}+34" = "exec ${config.home.homeDirectory}/bin/mutt_helper"; # Launch mutt
            "${modifier}+35" = "exec ${pkgs.element-desktop}/bin/element-desktop"; # Launch Element
          };

        modes = {
          "${resizeStr}" = {
            "${left}" = "resize shrink width 10 px or 10 ppt";
            "${down}" = "resize grow height 10 px or 10 ppt";
            "${up}" = "resize shrink height 10 px or 10 ppt";
            "${right}" = "resize grow width 10 px or 10 ppt";
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
            "Escape" = "mode default";
            "Return" = "mode default";
            "${modifier}+r" = "mode default";
          };
        };

        window = {
          border = 0;
          hideEdgeBorders = "both";
        };
      };
    };
}
