{ config, pkgs, ... }:
{
  # Temporary in-RAM Filesystems.
  fileSystems."/home/sumner/tmp" = {
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "size=32G" ];
  };

  fileSystems."/home/sumner/.cache" = {
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "size=32G" ];
  };
}
