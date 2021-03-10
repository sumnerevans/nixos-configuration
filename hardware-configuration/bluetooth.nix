{ config, lib, pkgs, ... }: with lib; let
  cfg = config.bluetooth;
in
{
  options = {
    bluetooth.enable = mkOption {
      type = types.bool;
      description = "Enable bluetooth stack";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Use the full pulseaudio that includes Bluetooth support.
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
  };
}
