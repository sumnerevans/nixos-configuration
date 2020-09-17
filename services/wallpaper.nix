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
  };

  systemd.user.timers.wallpaper = {
    description = "Set the wallpaper every 10 minutes.";
    timerConfig = {
      OnCalendar = "*:0/10";
    };
    wantedBy = [ "timers.target" ];
  };
}
