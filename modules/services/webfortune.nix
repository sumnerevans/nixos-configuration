{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.webfortune;
in
{
  options = {
    services.webfortune = {
      enable = mkEnableOption "webfortune";
      quotesfile = mkOption {
        type = types.path;
        description = "Path to the quotesfile";
      };
      sourceUrl = mkOption {
        type = types.str;
        description = "URL to the quotesfile";
      };
      virtualHost = mkOption {
        type = types.str;
        description = "The virtual host to use";
      };
      listenAddr = mkOption {
        type = types.str;
        default = "0.0.0.0:8477";
        description = "Address to listen on";
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts.${cfg.virtualHost} = {
        addSSL = true;
        enableACME = true;
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass = "http://${cfg.listenAddr}";
        };
      };
    };

    systemd.services.webfortune = {
      description = "webfortune";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        QUOTESFILE = cfg.quotesfile;
        QUOTESFILE_SOURCE_URL = cfg.sourceUrl;
        LISTEN_ADDR = cfg.listenAddr;
        GOATCOUNTER_DOMAIN = "https://fortune.goatcounter.com/count";
        HOST_ROOT = "https://${cfg.virtualHost}";
      };
      serviceConfig = {
        ExecStart = "${inputs.webfortune.packages.${pkgs.system}.webfortune}/bin/webfortune";
        Restart = "always";
      };
    };
  };
}
