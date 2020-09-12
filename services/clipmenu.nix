{ config, pkgs, ... }:
{
  services.clipmenu.enable = true;

  # Force using rofi instead of dmenu.
  environment.variables.CM_LAUNCHER = "rofi";
}
