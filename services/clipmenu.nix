{ config, pkgs, ... }:
{
  services.clipmenu.enable = true;
  environment.variables = {
    CM_LAUNCHER = "rofi";   # Use rofi
  };
}
