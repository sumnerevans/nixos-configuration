{ config, ... }:
{
  networking.domain = "sumnerevans.com";
  services.fail2ban.enable = true;
}
