{ config, pkgs, ... }:
{
  systemd.user.services.wallpaper = {
    description = "Set the wallpaper.";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/home/sumner/bin/set_wallpaper.sh";
    };
    path = with pkgs; [
      bashInteractive
      coreutils
      feh
      gnused
      imagemagick
      procps
    ];
    startAt = "*:0/10";
  };
}
