{ config, pkgs, lib, ... }: let
  hostName = lib.removeSuffix "\n" (builtins.readFile ./hostname);
  secretPath = secretName: "/etc/nixos/secrets/${secretName}";
in
{
  networking = {
    hostName = hostName;
    networkmanager = {
      enable = true;
      enableStrongSwan = true;
    };

    firewall.enable = false;

    wg-quick.interfaces = {
      wg0 = {
        address = [
          (
            lib.removeSuffix
              "\n"
              (builtins.readFile (secretPath "wireguard-${hostName}-ip"))
          )
        ];
        dns = [ "192.168.69.1" ];
        privateKeyFile = secretPath "wireguard-${hostName}-privatekey";

        peers = [
          {
            publicKey = "7FksnG2ME9XR02NVyNUsmfg87Uwk90Y4D7fgebxTJlM=";
            presharedKeyFile = secretPath "wireguard-${hostName}-presharedkey";
            allowedIPs = [ "0.0.0.0/0" "::/0" ];
            endpoint = "vpn.sumnerevans.com:51820";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    linuxPackages.wireguard
  ];
}
