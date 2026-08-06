{ lib, pkgs, ... }:
{
  imports = [ ../home.nix ];

  # windowManager.modKey = "Mod1"; # use Alt as modifier on mustafar
  wayland.enable = true;
  # niri.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    mainMod = "ALT";
    monitorScale = 1.67;
    settings = {
      config.input.kb_variant = lib.mkForce "3l-cros";

      bind =
        let
          lua = lib.generators.mkLuaInline;
          mod = s: lua ''mainMod .. " + ${s}"'';
        in
        [
          {
            _args = [
              (mod "F6")
              (lua ''hl.dsp.exec_cmd("dms ipc call brightness decrement 10 '''")'')
              { locked = true; }
            ];
          }
          {
            _args = [
              (mod "F7")
              (lua ''hl.dsp.exec_cmd("dms ipc call brightness increment 10 '''")'')
              { locked = true; }
            ];
          }
          {
            _args = [
              (mod "SHIFT + F6")
              (lua ''hl.dsp.exec_cmd("dms ipc call brightness decrement 10 leds:chromeos::kbd_backlight")'')
              { locked = true; }
            ];
          }
          {
            _args = [
              (mod "SHIFT + F7")
              (lua ''hl.dsp.exec_cmd("dms ipc call brightness increment 10 leds:chromeos::kbd_backlight")'')
              { locked = true; }
            ];
          }
          {
            _args = [
              (mod "F8")
              (lua ''hl.dsp.exec_cmd("dms ipc call audio mute")'')
              { locked = true; }
            ];
          }
          {
            _args = [
              (mod "F9")
              (lua ''hl.dsp.exec_cmd("dms ipc call audio decrement 5")'')
              { locked = true; }
            ];
          }
          {
            _args = [
              (mod "F10")
              (lua ''hl.dsp.exec_cmd("dms ipc call audio increment 5")'')
              { locked = true; }
            ];
          }
        ];
    };
  };
  dms.enable = true;

  mdf.port = 1024;

  home.packages = [ pkgs.pulseaudio ];

  programs.alacritty.settings.font.size = 11;

  home.symlinks =
    let
      links = [
        "Documents"
        "Pictures"
        "Screenshots"
        "Syncthing"
        "Videos"
      ];
    in
    builtins.listToAttrs (
      map (dirName: {
        name = dirName;
        value = "/mnt/data/${dirName}";
      }) links
    );
}
