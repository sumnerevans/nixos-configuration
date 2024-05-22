{ config, lib, ... }: {
  options = {
    hardware.isLaptop = lib.mkEnableOption "laptop-only configurations";
  };

  config = lib.mkIf config.hardware.isLaptop {
    # Enable TLP for power management
    services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
        RESTORE_THRESHOLDS_ON_BAT = 1;

        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";

        CPU_SCALING_MIN_FREQ_ON_AC = 800000;
        CPU_SCALING_MAX_FREQ_ON_AC = 3500000;
        CPU_SCALING_MIN_FREQ_ON_BAT = 800000;
        CPU_SCALING_MAX_FREQ_ON_BAT = 2300000;
      };
    };

    # UPower
    services.upower.enable = true;
  };
}
