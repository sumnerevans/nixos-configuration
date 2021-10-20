{ config, lib, ... }: with lib; let
  mkNginxLogsRotate = pathGlob: keep: {
    inherit keep;
    user = "nginx";
    group = "nginx";
    path = "/var/log/nginx/${pathGlob}.log";
    extraConfig = ''
      size 25M
      missingok
      compress
      delaycompress
      notifempty
      create 0644 nginx nginx
      sharedscripts
      postrotate
        /usr/bin/env kill -USR1 `cat /run/nginx/nginx.pid 2>/dev/null` 2>/dev/null || true
      endscript
    '';
  };
in
mkIf config.services.logrotate.enable {
  services.logrotate = {
    paths = {
      "nginx-sumnerevans-site" = mkIf config.services.nginx.enable (mkNginxLogsRotate "*sumnerevans.com*" 5);
      "nginx-tef" = mkIf config.services.nginx.enable (mkNginxLogsRotate "*the-evans.family*" 2);
      "nginx-matrix" = mkIf config.services.nginx.enable (mkNginxLogsRotate "matrix*" 2);
      "nginx-access-log" = mkIf config.services.nginx.enable (mkNginxLogsRotate "access*" 2);
    };
  };
}
