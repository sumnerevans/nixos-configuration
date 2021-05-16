{ config, lib, ... }: with lib; let
  cfg = config.services.openssh;
in
mkIf cfg.enable {
  services.openssh = {
    ports = [ 32 ];
    passwordAuthentication = false;
  };
}
