{ config, ... }:
let
  serverName = "grafana.${config.networking.hostName}.${config.networking.domain}";
  cfg = config.services.grafana;
in
{
  services.grafana = {
    enable = true;
    settings.server.domain = serverName;
    settings.security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
  };

  services.nginx.virtualHosts.${serverName} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString cfg.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };
}
