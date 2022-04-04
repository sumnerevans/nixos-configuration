{ config, lib, pkgs, ... }: with lib; let
  cfg = config.hardware.bluetooth;
in
{
  config = mkIf cfg.enable {
    services.blueman.enable = true;

    # Use the full pulseaudio that includes Bluetooth support.
    # hardware.pulseaudio.package = pkgs.pulseaudioFull;
  };
}
