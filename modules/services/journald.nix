{ config, lib, ... }: with lib;
{
  services.journald.extraConfig = ''
    SystemMaxUse=2G
  '';
}
