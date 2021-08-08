{ config, lib, options, pkgs, ... }: with lib; let
  serverName = "grafana.${config.networking.domain}";
in
mkIf config.services.grafana.enable {
  services.grafana.domain = serverName;

  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      proxyWebsockets = true;
    };
  };
}
