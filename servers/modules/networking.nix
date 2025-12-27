{ config, ... }: {
  networking.domain = "sumnerevans.com";
  services.fail2ban.enable = true;

  networking.firewall.allowedTCPPorts =
    [ 22 config.services.home-assistant.config.http.server_port ];
}
