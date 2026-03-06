{ config, lib, ... }:
with lib;
mkIf config.networking.firewall.enable { networking.firewall.allowPing = true; }
