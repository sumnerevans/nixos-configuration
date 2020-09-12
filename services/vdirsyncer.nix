{ config, pkgs, ... }:
{
  systemd.user.services.vdirsyncer = {
    description = "Synchronize Calendar and Contacts";
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.vdirsyncer}/bin/vdirsyncer metasync";
      ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
    };
    path = [ pkgs.pass ];
  };

  systemd.user.timers.vdirsyncer = {
    description = "Run vdirsyncer sync every 5 minutes";
    timerConfig = {
      OnCalendar = "*:0/5";
    };
  };
}

