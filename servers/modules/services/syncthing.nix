{ config, lib, ... }:
let
  hostnameDomain =
    "syncthing.${config.networking.hostName}.${config.networking.domain}";
  syncthingCfg = config.services.syncthing;
in lib.mkIf syncthingCfg.enable {
  services.syncthing = {
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
  };

  # Use nginx to expose Syncthing via reverse proxy.
  services.nginx.virtualHosts."${hostnameDomain}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:8384/";
      proxyWebsockets = true;
    };
  };

  # Add a backup service for the config.
  services.backup.backups.syncthing-config = {
    path = config.services.syncthing.dataDir;
  };

  # Add a backup service for the actual data.
  services.backup.backups.syncthing-data = { path = "/mnt/syncthing-data"; };
}
