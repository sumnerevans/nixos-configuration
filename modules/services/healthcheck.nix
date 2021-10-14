{ config, lib, pkgs, ... }: with lib;
let
  healthcheckCfg = config.services.healthcheck;
in
{
  options.services.healthcheck = {
    enable = mkEnableOption "the healthcheck ping service.";
    checkId = mkOption {
      type = types.str;
      description = "The healthchecks.io check ID.";
    };
  };

  config = mkIf healthcheckCfg.enable {
    systemd.services.healthcheck = {
      description = "Healthcheck service";
      startAt = "*:*:0/30"; # Send a healthcheck ping every 30 seconds.
      serviceConfig = {
        ExecStart = ''
          ${pkgs.curl}/bin/curl \
            --verbose \
            -fsS \
            --retry 2 \
            --max-time 5 \
            --ipv4 \
            https://hc-ping.com/${healthcheckCfg.checkId}
        '';
        TimeoutSec = 10;
      };
    };
  };
}
