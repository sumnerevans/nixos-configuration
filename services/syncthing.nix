{ pkgs, ... }: let
  username = "sumner";
in
{
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}/Syncthing";
    configDir = "/home/${username}/.config/syncthing";
  };

  # Syncthing tray
  systemd.user.services.qsyncthingtray = {
    description = "QSyncthingTray";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.qsyncthingtray}/bin/QSyncthingTray";
    };
  };
}
