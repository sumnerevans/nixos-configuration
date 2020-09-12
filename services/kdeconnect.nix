{ config, pkgs, ... }:
{
  systemd.user.services.kdeconnect-indicator = {
    description = "KDE Connect Indicator";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.kdeconnect}/bin/kdeconnect-indicator";
  };
}
