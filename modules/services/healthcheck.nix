{ config, lib, pkgs, ... }:
with lib;
let
  healthcheckCfg = config.services.healthcheck;
  threshold = 97;

  healthcheckCurl = fail: ''
    ${pkgs.curl}/bin/curl \
      --verbose \
      -fsS \
      --retry 2 \
      --max-time 5 \
      --ipv4 \
      https://hc-ping.com/${healthcheckCfg.checkId}${
        optionalString fail "/fail"
      }
  '';

  diskCheckScript = with pkgs;
    disk:
    writeShellScriptBin "diskcheck" ''
      set -xe
      CURRENT=$(${coreutils}/bin/df ${disk} | ${gnugrep}/bin/grep ${disk} | ${gawk}/bin/awk '{ print $5}' | ${gnused}/bin/sed 's/%//g')

      if [ "$CURRENT" -gt "${toString threshold}" ] ; then
        echo "Used space on ${disk} is over ${toString threshold}%"
        ${healthcheckCurl true}
        exit 1
      fi
    '';

  healthcheckScript = pkgs.writeShellScriptBin "healthcheck" ''
    set -xe

    ${concatMapStringsSep "\n" (disk: "${diskCheckScript disk}/bin/diskcheck")
    healthcheckCfg.disks}

    # Everything worked, so success.
    ${healthcheckCurl false}
  '';
in {
  options.services.healthcheck = {
    enable = mkEnableOption "the healthcheck ping service.";
    checkId = mkOption {
      type = types.str;
      description = "The healthchecks.io check ID.";
    };
    disks = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "List of paths to disks to check for usage thresholds";
    };
  };

  config = mkIf healthcheckCfg.enable {
    systemd.services.healthcheck = {
      description = "Healthcheck service";
      startAt = "*:*:0/30"; # Send a healthcheck ping every 30 seconds.
      serviceConfig = {
        ExecStart = "${healthcheckScript}/bin/healthcheck";
        TimeoutSec = 10;
      };
    };
  };
}
