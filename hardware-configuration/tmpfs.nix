{ config, lib, ... }: with lib; let
  cfg = config.hardware;
in
{
  options = {
    hardware.ramSize = mkOption {
      type = types.int;
      description = "How much RAM the hardware has.";
    };
  };

  config.fileSystems = {
    # Temporary in-RAM Filesystems.
    "/home/sumner/tmp" = {
      fsType = "tmpfs";
      options = [ "nosuid" "nodev" "size=${toString cfg.ramSize}G" ];
    };

    "/home/sumner/.cache" = {
      fsType = "tmpfs";
      options = [ "nosuid" "nodev" "size=${toString cfg.ramSize}G" ];
    };
  };
}
