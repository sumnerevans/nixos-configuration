{ config, pkgs, ... }:
{
  # Temporary in-RAM Filesystems.
  fileSystems."${config.users.users.sumner.home}/tmp" = {
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "size=32G" ];
  };

  fileSystems."${config.users.users.sumner.home}/.cache" = {
    fsType = "tmpfs";
    options = [ "nosuid" "nodev" "size=32G" ];
  };
}
