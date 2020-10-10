{ config, pkgs, ... }: let
  # mailnotify = pkgs.callPackage ../pkgs/mailnotify.nix { };
in
{
  # systemd.user.services.mailnotify = {
  #   description = "Run a daemon for notifications for email.";
  #   wantedBy = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   serviceConfig.ExecStart = "${mailnotify}/bin/mailnotify";
  # };
}
