{ config, lib, ... }:
let
  serverName = "bitwarden.${config.networking.domain}";
  bitwardenCfg = config.services.vaultwarden;
in lib.mkIf bitwardenCfg.enable {
  services.vaultwarden = {
    config = {
      domain = "https://${serverName}";
      rocketAddress = "0.0.0.0";
      rocketLog = "critical";
      rocketPort = 8222;
      signupsAllowed = false;
      websocketAddress = "0.0.0.0";
      websocketEnabled = true;
      websocketPort = 3012;
    };
  };

  # Reverse proxy Bitwarden.
  services.nginx.virtualHosts."${serverName}" = {
    forceSSL = true;
    enableACME = true;
    locations = { "/".proxyPass = "http://127.0.0.1:8222"; };
  };

  # Add a backup service.
  services.backup.backups.bitwarden = { path = "/var/lib/bitwarden_rs"; };
}
