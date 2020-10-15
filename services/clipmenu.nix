{ config, pkgs, ... }:
{
  services.clipmenu.enable = true;

  # Force using rofi instead of dmenu.
  environment.variables = {
    CM_HISTLENGTH = "20";
    CM_LAUNCHER = "rofi";
  };
}
