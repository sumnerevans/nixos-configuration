{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ grimblast ];

    services.polkit-gnome.enable = true;

    xdg.portal.config.hyprland = {
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    };

    systemd.user.services.dms = {
      Unit.After = [ "hyprland-session.target" ];
    };

    wayland.windowManager.hyprland = {
      systemd.enable = true;
      configType = "lua";

      settings = {
        mainMod = {
          _var = "SUPER";
        };

        bind =
          let
            lua = lib.generators.mkLuaInline;
            mod = s: lua ''mainMod .. " + ${s}"'';
          in
          [
            # Apps
            {
              _args = [
                (mod "Return")
                (lua ''hl.dsp.exec_cmd("kitty")'')
              ];
            }
            {
              _args = [
                (mod "D")
                (lua ''hl.dsp.exec_cmd("dms ipc call spotlight toggle")'')
              ];
            }
            {
              _args = [
                (mod "Space")
                (lua ''hl.dsp.exec_cmd("dms ipc call spotlight toggle")'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + X")
                (lua ''hl.dsp.exec_cmd("dms ipc call lock lock")'')
              ];
            }
            {
              _args = [
                (mod "C")
                (lua ''hl.dsp.exec_cmd("dms ipc call clipboard open")'')
              ];
            }
            {
              _args = [
                (mod "backslash")
                (lua ''hl.dsp.exec_cmd("~/bin/mutt_helper")'')
              ];
            }

            # Window management
            {
              _args = [
                (mod "SHIFT + Q")
                (lua "hl.dsp.window.close()")
              ];
            }
            {
              _args = [
                "ALT + F4"
                (lua "hl.dsp.window.close()")
              ];
            }

            # Focus
            {
              _args = [
                (mod "H")
                (lua ''hl.dsp.focus({ direction = "left" })'')
              ];
            }
            {
              _args = [
                (mod "J")
                (lua ''hl.dsp.focus({ direction = "down" })'')
              ];
            }
            {
              _args = [
                (mod "K")
                (lua ''hl.dsp.focus({ direction = "up" })'')
              ];
            }
            {
              _args = [
                (mod "L")
                (lua ''hl.dsp.focus({ direction = "right" })'')
              ];
            }
            {
              _args = [
                (mod "left")
                (lua ''hl.dsp.focus({ direction = "left" })'')
              ];
            }
            {
              _args = [
                (mod "down")
                (lua ''hl.dsp.focus({ direction = "down" })'')
              ];
            }
            {
              _args = [
                (mod "up")
                (lua ''hl.dsp.focus({ direction = "up" })'')
              ];
            }
            {
              _args = [
                (mod "right")
                (lua ''hl.dsp.focus({ direction = "right" })'')
              ];
            }

            # Move windows
            {
              _args = [
                (mod "SHIFT + H")
                (lua ''hl.dsp.window.move({ direction = "left" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + J")
                (lua ''hl.dsp.window.move({ direction = "down" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + K")
                (lua ''hl.dsp.window.move({ direction = "up" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + L")
                (lua ''hl.dsp.window.move({ direction = "right" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + left")
                (lua ''hl.dsp.window.move({ direction = "left" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + down")
                (lua ''hl.dsp.window.move({ direction = "down" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + up")
                (lua ''hl.dsp.window.move({ direction = "up" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + right")
                (lua ''hl.dsp.window.move({ direction = "right" })'')
              ];
            }

            # Focus monitor
            {
              _args = [
                (mod "CTRL + H")
                (lua ''hl.dsp.focus({ monitor = "l" })'')
              ];
            }
            {
              _args = [
                (mod "CTRL + J")
                (lua ''hl.dsp.focus({ monitor = "d" })'')
              ];
            }
            {
              _args = [
                (mod "CTRL + K")
                (lua ''hl.dsp.focus({ monitor = "u" })'')
              ];
            }
            {
              _args = [
                (mod "CTRL + L")
                (lua ''hl.dsp.focus({ monitor = "r" })'')
              ];
            }
            {
              _args = [
                (mod "CTRL + left")
                (lua ''hl.dsp.focus({ monitor = "l" })'')
              ];
            }
            {
              _args = [
                (mod "CTRL + down")
                (lua ''hl.dsp.focus({ monitor = "d" })'')
              ];
            }
            {
              _args = [
                (mod "CTRL + up")
                (lua ''hl.dsp.focus({ monitor = "u" })'')
              ];
            }
            {
              _args = [
                (mod "CTRL + right")
                (lua ''hl.dsp.focus({ monitor = "r" })'')
              ];
            }

            # Move workspace to monitor
            {
              _args = [
                (mod "SHIFT + CTRL + H")
                (lua ''hl.dsp.workspace.move({ monitor = "l" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + CTRL + J")
                (lua ''hl.dsp.workspace.move({ monitor = "d" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + CTRL + K")
                (lua ''hl.dsp.workspace.move({ monitor = "u" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + CTRL + L")
                (lua ''hl.dsp.workspace.move({ monitor = "r" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + CTRL + left")
                (lua ''hl.dsp.workspace.move({ monitor = "l" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + CTRL + down")
                (lua ''hl.dsp.workspace.move({ monitor = "d" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + CTRL + up")
                (lua ''hl.dsp.workspace.move({ monitor = "u" })'')
              ];
            }
            {
              _args = [
                (mod "SHIFT + CTRL + right")
                (lua ''hl.dsp.workspace.move({ monitor = "r" })'')
              ];
            }

            # Workspace prev/next
            {
              _args = [
                (mod "prior")
                (lua ''hl.dsp.focus({ workspace = "e-1" })'')
              ];
            }
            {
              _args = [
                (mod "next")
                (lua ''hl.dsp.focus({ workspace = "e+1" })'')
              ];
            }

            # Window state
            {
              _args = [
                (mod "F")
                (lua "hl.dsp.window.fullscreen({ mode = 1 })")
              ];
            }
            {
              _args = [
                (mod "SHIFT + F")
                (lua "hl.dsp.window.fullscreen({ mode = 0 })")
              ];
            }
            {
              _args = [
                (mod "V")
                (lua ''hl.dsp.window.float({ action = "toggle" })'')
              ];
            }

            # Power
            {
              _args = [
                (mod "SHIFT + P")
                (lua ''hl.dsp.dpms({ state = "off" })'')
              ];
            }

            # Screenshots
            {
              _args = [
                "Print"
                (lua ''hl.dsp.exec_cmd("grimblast --notify copy area")'')
              ];
            }
            {
              _args = [
                "CTRL + Print"
                (lua ''hl.dsp.exec_cmd("grimblast --notify copy screen")'')
              ];
            }
            {
              _args = [
                "ALT + Print"
                (lua ''hl.dsp.exec_cmd("grimblast --notify copy active")'')
              ];
            }

            # Session
            {
              _args = [
                (mod "SHIFT + E")
                (lua "hl.dsp.exit()")
              ];
            }
            {
              _args = [
                "CTRL + ALT + Delete"
                (lua "hl.dsp.exit()")
              ];
            }

            # Media keys (locked)
            {
              _args = [
                "XF86AudioRaiseVolume"
                (lua ''hl.dsp.exec_cmd("dms ipc call audio increment 5")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioLowerVolume"
                (lua ''hl.dsp.exec_cmd("dms ipc call audio decrement 5")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioMute"
                (lua ''hl.dsp.exec_cmd("dms ipc call audio mute")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioMicMute"
                (lua ''hl.dsp.exec_cmd("dms ipc call audio micmute")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioPlay"
                (lua ''hl.dsp.exec_cmd("dms ipc call mpris playPause")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioStop"
                (lua ''hl.dsp.exec_cmd("dms ipc call mpris stop")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioPrev"
                (lua ''hl.dsp.exec_cmd("dms ipc call mpris previous")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioNext"
                (lua ''hl.dsp.exec_cmd("dms ipc call mpris next")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86MonBrightnessUp"
                (lua ''hl.dsp.exec_cmd("dms ipc call brightness increment 10 '''")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86MonBrightnessDown"
                (lua ''hl.dsp.exec_cmd("dms ipc call brightness decrement 10 '''")'')
                { locked = true; }
              ];
            }

            # Mouse bindings
            {
              _args = [
                (mod "mouse:272")
                (lua "hl.dsp.window.drag()")
                { mouse = true; }
              ];
            }
            {
              _args = [
                (mod "mouse:273")
                (lua "hl.dsp.window.resize()")
                { mouse = true; }
              ];
            }
          ]
          ++ builtins.concatMap (i: [
            # Workspaces 1–9
            {
              _args = [
                (mod "${toString i}")
                (lua "hl.dsp.focus({ workspace = ${toString i} })")
              ];
            }
            {
              _args = [
                (mod "SHIFT + ${toString i}")
                (lua "hl.dsp.window.move({ workspace = ${toString i}, follow = false })")
              ];
            }
          ]) (lib.range 1 9)
          ++
            builtins.concatMap
              ({ ws, key }: [
                # Workspaces 10–12
                {
                  _args = [
                    (mod key)
                    (lua "hl.dsp.focus({ workspace = ${toString ws} })")
                  ];
                }
                {
                  _args = [
                    (mod "SHIFT + ${key}")
                    (lua "hl.dsp.window.move({ workspace = ${toString ws}, follow = false })")
                  ];
                }
              ])
              [
                {
                  ws = 10;
                  key = "0";
                }
                {
                  ws = 11;
                  key = "minus";
                }
                {
                  ws = 12;
                  key = "equal";
                }
              ];

        curve = {
          _args = [
            "easeOut"
            {
              type = "bezier";
              points = [
                [
                  0.0
                  0.9
                ]
                [
                  0.1
                  1.0
                ]
              ];
            }
          ];
        };

        animation = [
          {
            leaf = "windows";
            enabled = true;
            speed = 2;
            bezier = "easeOut";
            style = "slide";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 2;
            bezier = "easeOut";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 2;
            bezier = "easeOut";
            style = "slide";
          }
          {
            leaf = "border";
            enabled = true;
            speed = 2;
            bezier = "easeOut";
          }
        ];

        gesture = [
          {
            fingers = 3;
            direction = "horizontal";
            action = "workspace";
          }
        ];

        monitor = [
          {
            output = "eDP-1";
            mode = "preferred";
            position = "0x0";
            scale = 1;
          }
        ];

        device = [
          {
            name = "zsa-technology-labs-voyager";
            kb_layout = "us";
            kb_variant = "";
            numlock_by_default = true;
          }
        ];

        config = {
          input = {
            kb_layout = "us";
            kb_variant = "3l";
            numlock_by_default = true;
            follow_mouse = 1;
            natural_scroll = true;
            resolve_binds_by_sym = true;
            touchpad = {
              natural_scroll = true;
              tap_to_click = false;
              clickfinger_behavior = true;
            };
          };
          general = {
            gaps_in = 4;
            gaps_out = 8;
            layout = "dwindle";
          };
          decoration = {
            rounding = 8;
            shadow.enabled = false;
            active_opacity = 1.0;
            inactive_opacity = 0.8;
          };
          animations.enabled = true;
          dwindle = {
            preserve_split = true;
            force_split = 2;
          };
          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            focus_on_activate = true;
          };
        };
        window_rule = [
          {
            _args = [
              {
                name = "no-opacity-mpv";
                match.class = "mpv";
                opacity = "1.0 override";
              }
            ];
          }
          {
            _args = [
              {
                name = "no-opacity-feh";
                match.class = "feh";
                opacity = "1.0 override";
              }
            ];
          }
        ];
      };

    };
  };
}
