{ config, pkgs, ... }:
{
  systemd.user.services.vdirsyncer = {
    description = "Synchronize Calendar and Contacts";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
      ExecStartPost = "${pkgs.vdirsyncer}/bin/vdirsyncer metasync";
    };
    path = [ pkgs.pass ];
  };

  systemd.user.timers.vdirsyncer = {
    description = "Run vdirsyncer sync every 5 minutes";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/5";
    };
  };
}
