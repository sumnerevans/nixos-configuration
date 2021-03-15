{ config, lib, pkgs, ... }: with lib; let
  cfg = config.xorg;
in
{
  options = {
    xorg = {
      enable = mkOption {
        type = types.bool;
        description = "Enable the Xorg stack";
        default = false;
      };

      xkbVariant = mkOption {
        type = types.str;
        description = "The XKB variant to use";
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;
      windowManager.i3.enable = true;

      # Use 3l
      layout = "us";
      xkbVariant = mkIf (cfg.xkbVariant != "") cfg.xkbVariant;

      # Enable touchpad support.
      libinput = {
        enable = true;
        touchpad.tapping = false;
      };
    };
  };
}
