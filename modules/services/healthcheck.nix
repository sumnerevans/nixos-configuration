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
      startAt = "*:0/1"; # Run a ping every minute to ensure that the server is up.
      serviceConfig = {
        ExecStart = "${pkgs.curl}/bin/curl -fsS --retry 10 https://hc-ping.com/${healthcheckCfg.checkId}";
      };
    };
  };
}
