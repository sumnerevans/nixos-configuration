{ config, lib, ... }:
let
  hostnameDomain = "${config.networking.hostName}.${config.networking.domain}";
  longviewCfg = config.services.longview;
in
lib.mkIf longviewCfg.enable {
  services.longview = {
    apiKeyFile = ../../secrets/longview-api-key;
    nginxStatusUrl = "https://${hostnameDomain}/status";
  };
}
