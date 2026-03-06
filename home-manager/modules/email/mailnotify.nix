{
  config,
  lib,
  pkgs,
  ...
}:
let
  mailnotify = pkgs.callPackage ../../pkgs/mailnotify.nix { };
  hasGui = config.wayland.enable || config.xorg.enable;
in
{
  systemd.user.services.mailnotify = lib.mkIf hasGui {
    Unit = {
      Description = "mailnotify daemon";
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = ''
        ${mailnotify}/bin/mailnotify ${config.accounts.email.maildirBasePath} ${pkgs.gnome-icon-theme}/share/icons/gnome/48x48/status/mail-unread.png
      '';
      Restart = "always";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
