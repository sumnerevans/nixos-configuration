# See: https://nixos.org/nixos/manual/index.html#module-services-matrix-synapse
{ config, lib, pkgs, ... }:
let
  turnDomain = "turn.${config.networking.domain}";
  certs = config.security.acme.certs;
  staticAuthSecret = lib.removeSuffix "\n" (builtins.readFile ../../../secrets/coturn-static-auth-secret);
in
# TODO actually figure this out eventually
# TODO will need to convert to use matrix-synapse-custom
lib.mkIf (false && config.services.matrix-synapse.enable) {
  services.coturn = rec {
    enable = true;
    no-cli = true;
    no-tcp-relay = true;
    min-port = 49000;
    max-port = 50000;
    use-auth-secret = true;
    static-auth-secret = staticAuthSecret;
    realm = turnDomain;
    cert = "${certs.${turnDomain}.directory}/full.pem";
    pkey = "${certs.${turnDomain}.directory}/key.pem";
    extraConfig = ''
      # for debugging
      verbose
      # ban private IP ranges
      no-multicast-peers
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=100.64.0.0-100.127.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      denied-peer-ip=192.0.0.0-192.0.0.255
      denied-peer-ip=192.0.2.0-192.0.2.255
      denied-peer-ip=192.88.99.0-192.88.99.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=198.18.0.0-198.19.255.255
      denied-peer-ip=198.51.100.0-198.51.100.255
      denied-peer-ip=203.0.113.0-203.0.113.255
      denied-peer-ip=240.0.0.0-255.255.255.255
      denied-peer-ip=::1
      denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
      denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
      denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
      denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
    '';
  };

  # open the firewall
  networking.firewall = {
    interfaces.enp2s0 =
      let
        ranges = with config.services.coturn; [
          { from = min-port; to = max-port; }
        ];
      in
        {
          allowedUDPPortRanges = ranges;
          allowedUDPPorts = [ 3478 ];
          allowedTCPPortRanges = ranges;
          allowedTCPPorts = [ 3478 ];
        };
  };

  # get a certificate
  services.nginx.virtualHosts.${turnDomain}.enableACME = true;
  security.acme.certs.${turnDomain} = {
    group = "turnserver";
    postRun = "systemctl restart coturn.service";
  };
  users.groups.turnserver.members = [ "turnserver" "nginx" ];

  # configure synapse to point users to coturn
  services.matrix-synapse = with config.services.coturn; {
    turn_uris = [
      "turn:${turnDomain}:3478?transport=udp"
      "turn:${turnDomain}:3478?transport=tcp"
    ];
    turn_shared_secret = staticAuthSecret;
    turn_user_lifetime = "1h";
  };
}
