{ config, pkgs, ... }:
{
  services.picom = {
    enable = true;

    # General
    vSync = true;

    # Fade
    fade = true;
    fadeDelta = 5;

    # Opacity
    inactiveOpacity = 0.8;
    opacityRules = [
      "100:class_g = 'obs'"
      "100:class_g = 'i3lock'"
    ];

    # Shadow
    shadow = true;
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "class_g = 'i3-frame'"
      "_GTK_FRAME_EXTENTS@:c"
    ];

    # Custom styles for various window types
    wintypes = {
      tooltip = { shadow = true; opacity = 0.9; focus = true; full-shadow = false; };
      dock = { shadow = false; };
      dnd = { shadow = false; };
      popup_menu = { opacity = 0.9; };
      dropdown_menu = { opacity = 0.9; };
    };
  };
}
