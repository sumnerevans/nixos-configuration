{ config, lib, options, pkgs, ... }: with lib; let
  cfg = config.services.mineshspc;
in
{
  options.services.mineshspc = {
    enable = mkEnableOption "the mineshspc.com website";
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/mineshspc";
    };
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."mineshspc.com" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://0.0.0.0:8090"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/mineshspc.access.log;
        '';
      };
    };

    virtualisation.oci-containers.containers = {
      "mineshspc.com" = {
        image = "ghcr.io/coloradoschoolofmines/mineshspc.com:e01bc8cb248bc596dd9b3690c3d7b853450ccf11";
        volumes = [ "${cfg.dataDir}:/data" ];
        ports = [ "8090:8090" ];
      };
    };
  };
}