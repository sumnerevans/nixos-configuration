{
  pkgs,
  ...
}:
let
  listenAddr = "0.0.0.0:8477";
in
{
  services.nginx = {
    enable = true;
    virtualHosts."fortune.sumnerevans.com" = {
      addSSL = true;
      enableACME = true;
      locations."/" = {
        recommendedProxySettings = true;
        proxyPass = "http://${listenAddr}";
      };
    };
  };

  systemd.services.webfortune = {
    description = "webfortune";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    environment = {
      QUOTESFILE = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/sumnerevans/nixos-configuration/refs/heads/master/home-manager/modules/email/quotes";
        hash = "sha256-B4HrxSCEV5rO5BptTiNsncPgUUV57kQpb3AJY+wvyoE=";
      };
      QUOTESFILE_SOURCE_URL = "https://github.com/sumnerevans/home-manager-config/blob/master/modules/email/quotes";
      LISTEN_ADDR = listenAddr;
      GOATCOUNTER_DOMAIN = "https://fortune.goatcounter.com/count";
      HOST_ROOT = "https://fortune.sumnerevans.com";
    };
    serviceConfig = {
      ExecStart = "${pkgs.webfortune}/bin/webfortune";
      Restart = "always";
    };
  };
}
