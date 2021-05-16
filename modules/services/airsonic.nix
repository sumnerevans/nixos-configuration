{ config, lib, ... }:
let
  serverName = "airsonic.${config.networking.domain}";
  airsonicCfg = config.services.airsonic;
in
lib.mkIf airsonicCfg.enable {
  # Create the airsonic service.
  services.airsonic = {
    maxMemory = 1024;
    virtualHost = serverName;
  };

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
