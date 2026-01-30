{ config, lib, ... }:
let
  serverName = "airsonic.${config.networking.domain}";
  airsonicCfg = config.services.airsonic;
in lib.mkIf airsonicCfg.enable {
  # Create the airsonic service.
  services.airsonic = {
    maxMemory = 1024;
    virtualHost = serverName;
  };

  users.groups.music = { };
  systemd.services.airsonic.serviceConfig.Group = "music";
  users.users.airsonic.extraGroups = [ "music" ];

  services.nginx.virtualHosts = {
    ${serverName} = {
      forceSSL = true;
      enableACME = true;
    };
  };

  # Add a backup service.
  services.backup.backups.airsonic = {
    path = config.users.users.airsonic.home;
  };
}
