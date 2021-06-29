{ config, lib, ... }:
let
  hostnameDomain = "${config.networking.hostName}.${config.networking.domain}";
  longviewCfg = config.services.longview;
in
lib.mkIf longviewCfg.enable {
  services.longview = {
    nginxStatusUrl = "https://${hostnameDomain}/status";
  };
}
