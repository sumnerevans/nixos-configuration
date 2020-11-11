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
  };
}
