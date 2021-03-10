{ config, lib, ... }: with lib; let
  cfg = config.hardware;
in
{
  options = {
    hardware.isLaptop = mkOption {
      type = types.bool;
      description = "Specify that this host is a laptop.";
      default = false;
    };
  };

  config = {
    # Enable powertop for power management.
    powerManagement.powertop.enable = cfg.isLaptop;

    # UPower
    services.upower.enable = true;
  };
}
