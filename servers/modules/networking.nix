{ config, lib, ... }:
{
  config = {
    networking.domain = "sumnerevans.com";
    services.fail2ban.enable = true;

    networking.firewall = lib.mkIf config.networking.firewall.enable {
      allowPing = true;
    };
  };
}
