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
  };
}
