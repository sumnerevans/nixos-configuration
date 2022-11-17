{ config, lib, options, pkgs, ... }: with lib; let
  serverName = "grafana.${config.networking.hostName}.${config.networking.domain}";
in
mkIf config.services.grafana.enable {
  services.grafana = {
    domain = serverName;
    settings = { };
  };

  services.nginx.virtualHosts = mkIf config.hardware.isServer {
    ${config.services.grafana.domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
      };
    };
  };
}
