{ config, lib, ... }: with lib; let
  cfg = config.hardware;
in
{
  options = {
    hardware.isLaptop = mkEnableOption "laptop-only configurations";
  };

  config = {
    # Enable powertop for power management.
    powerManagement.powertop.enable = cfg.isLaptop;

    # UPower
    services.upower.enable = true;
  };
}
