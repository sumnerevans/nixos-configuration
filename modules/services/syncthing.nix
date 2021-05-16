{ config, lib, ... }:
let
  certs = config.security.acme.certs;
  hostnameDomain = "${config.networking.hostName}.${config.networking.domain}";
  syncthingCfg = config.services.syncthing;
in
lib.mkIf syncthingCfg.enable {
  services.syncthing = {
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
  };

  # Use nginx to expose Syncthing via reverse proxy.
  services.nginx.virtualHosts."${hostnameDomain}" = {
    locations."/syncthing/".proxyPass = "http://localhost:8384/";
  };

  # Add a backup service for the config.
  services.backup.backups.syncthing-config = {
    path = config.services.syncthing.dataDir;
  };

  # Add a backup service for the actual config.
  services.backup.backups.syncthing-data = {
    path = "/mnt/syncthing-data";
  };
}
