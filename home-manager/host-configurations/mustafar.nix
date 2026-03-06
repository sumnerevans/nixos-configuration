rec {
  wayland.enable = true;
  laptop.enable = true;
  networking.interfaces = [ "wlp0s20f3" ];
  windowManager.modKey = "Mod1"; # use Alt as modifier on mustafar

  programs.alacritty.settings.font.size = 11;

  mdf.port = 1024;

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

  wayland.extraSwayConfig.config = {
    # Scale to 1.8 instead of 2.
    output.eDP-1.scale = "1.75";
    input = {
      "1:1:AT_Translated_Set_2_keyboard" = {
        xkb_layout = "us";
        xkb_variant = "3l-cros";
      };

      # Don't scroll so fast
      "1739:52731:Synaptics_TM3579-001".scroll_factor = "0.75";

      # Map the inputs so rotation works.
      "11551:157:WCOM50C1:00_2D1F:009D".map_to_output = "eDP-1";
      "0:0:Elan_Touchscreen".map_to_output = "eDP-1";
    };

    keybindings = {
      # F6/F7 are the brightness up/down keys. Without mod, change screen
      # brightness. With mod, change the keyboard.
      "${windowManager.modKey}+F6" = "exec brightnessctl s 5%-";
      "${windowManager.modKey}+F7" = "exec brightnessctl s 5%+";
      "${windowManager.modKey}+Shift+F6" = "exec brightnessctl -d chromeos::kbd_backlight s 1%-";
      "${windowManager.modKey}+Shift+F7" = "exec brightnessctl -d chromeos::kbd_backlight s 1%+";
    };
  };
}
