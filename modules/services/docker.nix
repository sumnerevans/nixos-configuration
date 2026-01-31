{
  config,
  lib,
  pkgs,
  ...
}:
let
  dockerCfg = config.virtualisation.docker;
in
lib.mkIf dockerCfg.enable {
  environment.systemPackages = [ pkgs.docker-compose ];
}
