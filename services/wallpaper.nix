{ config, pkgs, ... }:
{
  systemd.user.services.wallpaper = {
    description = "Set the wallpaper.";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/home/sumner/bin/set_wallpaper.sh";
    };
    environment = {
      DISPLAY = ":0";
    };
    path = with pkgs; [
      bashInteractive
      coreutils
      feh
      gnused
      imagemagick
      procps
      sway
    ];
    startAt = "*:0/10";
  };
}
