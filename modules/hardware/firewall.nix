{ config, lib, pkgs, ... }: with lib;
mkIf config.firewall.enable {
  networking.firewall.allowPing = true;
}
