{ config, lib, ... }:
{
  options = {
    hardware.isLaptop = lib.mkEnableOption "laptop-only configurations";
  };

  config = lib.mkIf config.hardware.isLaptop {
    # UPower
    services.upower.enable = true;
  };
}
