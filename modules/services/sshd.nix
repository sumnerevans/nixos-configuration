{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.openssh;
in
{
  config = mkIf cfg.enable {
    services.openssh = {
      ports = [ 32 ];
      passwordAuthentication = false;
    };
  };
}
