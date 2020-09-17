{ config, pkgs, lib, ... }:
{
  networking = {
    hostName = lib.removeSuffix "\n" (builtins.readFile ./hostname);
    networkmanager = {
      enable = true;
      enableStrongSwan = true;
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;

    wg-quick.interfaces = {
      wg0 = {
        address = [ "192.168.69.2" ];
        dns = [ "192.168.69.1" ];
        privateKeyFile = "/etc/nixos/secrets/wireguard-privatekey";

        peers = [
          {
            publicKey = "7FksnG2ME9XR02NVyNUsmfg87Uwk90Y4D7fgebxTJlM=";
            presharedKeyFile = "/etc/nixos/secrets/wireguard-jedha-presharedkey";
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
