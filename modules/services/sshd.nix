{ config, lib, ... }: with lib; let
  cfg = config.services.openssh;
in
mkIf cfg.enable {
  services.openssh = {
    passwordAuthentication = false;
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };
}
