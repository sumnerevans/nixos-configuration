{ config, pkgs, ... }:
{
  systemd.user.services.nextcloud-client = {
    description = "Run Nextcloud client";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud";
  };
}
