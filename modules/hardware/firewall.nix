{ config, lib, pkgs, ... }: with lib;
mkIf config.networking.firewall.enable {
  networking.firewall.allowPing = true;
}
