{ config, lib, ... }:
with lib;
let cfg = config.hardware;
in {
  options = {
    hardware.enableVideoLoopback = mkOption {
      type = types.bool;
      description = "Enable v4l2loopback for loopback from OBS.";
      default = false;
    };
  };

  config = mkIf cfg.enableVideoLoopback {
    # For piping video capture of the screen back to a video output.
    boot.kernelModules = [ "v4l2loopback" ];
    boot.extraModulePackages = with config.boot.kernelPackages;
      [ v4l2loopback ];
    environment.etc."modprobe.d/v4l2loopback.conf".text = ''
      options v4l2loopback exclusive_caps=1 video_nr=10 card_label="OBS Virtual Output"
    '';
  };
}
