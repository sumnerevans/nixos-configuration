{ config, pkgs, ... }: let
  mailnotify = pkgs.callPackage ../pkgs/mailnotify.nix {};
in
{
  systemd.user.services.mailnotify = {
    description = "Run a daemon for notifications for email.";
    environment = {
      ICON_PATH = "${pkgs.gnome-icon-theme}/share/icons/gnome/48x48/status/mail-unread.png";
    };
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig.ExecStart = "${mailnotify}/bin/mailnotify";
  };
}
