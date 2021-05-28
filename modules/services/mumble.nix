{ config, lib, ... }:
let
  certs = config.security.acme.certs;
  serverName = "mumble.${config.networking.domain}";
  certDirectory = "${certs.${serverName}.directory}";
  port = config.services.murmur.port;

  murmurCfg = config.services.murmur;
in
lib.mkIf murmurCfg.enable {
  services.murmur = {
    registerHostname = serverName;
    registerName = "Sumner's Mumble Server";
    welcometext = ''
      Welcome to Sumner's Mumble Server.

      If you are here for office hours, join the "Office Hours" channel. I will
      manually move you to a breakout room if necessary.
    '';

    # Keys
    sslCert = "${certDirectory}/fullchain.pem";
    sslKey = "${certDirectory}/key.pem";
    sslCa = "${certDirectory}/full.pem";
  };

  # Open up the ports for TCP and UDP
  networking.firewall = {
    allowedTCPPorts = [ 64738 ];
    allowedUDPPorts = [ 64738 ];
  };

  # Use nginx to do the ACME verification for mumble.
  services.nginx.virtualHosts."${serverName}" = {
    enableACME = true;
    locations."/".return = "301 https://mumble.info";
  };

  # https://github.com/NixOS/nixpkgs/issues/106068#issuecomment-739534275
  security.acme.certs.${serverName}.group = "murmur-cert";
  security.acme.certs.${serverName}.postRun = "systemctl restart murmur.service";
  users.groups.murmur-cert.members = [ "murmur" "nginx" ];

  # Add a backup service.
  services.backup.backups.murmur = {
    path = config.users.users.murmur.home;
  };
}
