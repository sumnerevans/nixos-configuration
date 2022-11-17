{ config, lib, options, pkgs, ... }: with lib; let
  serverName = "grafana.${config.networking.hostName}.${config.networking.domain}";
  cfg = config.services.grafana;
in
mkIf cfg.enable {
  services.grafana = {
    settings = {
      server = mkIf config.hardware.isServer { domain = serverName; };
    };
  };

  services.nginx.virtualHosts = mkIf config.hardware.isServer {
    ${cfg.domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.server.http_port}";
        proxyWebsockets = true;
      };
    };
  };
}
