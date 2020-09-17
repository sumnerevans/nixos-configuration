{ config, pkgs, ... }:
{
  systemd.user.services.mailnotify = {
    description = "Run a daemon for notifications for email.";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "/home/sumner/bin/mailnotify.py";
    path = with pkgs; [
      libnotify
      (python38.withPackages(ps: with ps; [
        notify
        pygobject3
      ]))
    ];
  };
}
