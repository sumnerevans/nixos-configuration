{ config, pkgs, ... }: let
  offlinemsmtp = pkgs.callPackage ../pkgs/offlinemsmtp.nix {};
in
{
  systemd.user.services.offlinemsmtp = {
    description = "offlinemsmtp daemon";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = ''
        ${offlinemsmtp}/bin/offlinemsmtp --daemon \
          --send-mail-file /home/sumner/tmp/offlinemsmtp-sendmail
      '';
      Restart = "always";
      RestartSec = 5;
    };
  };
}
