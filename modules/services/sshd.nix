{ config, lib, ... }:
with lib;
let cfg = config.services.openssh;
in mkIf cfg.enable {
  services.openssh.settings = { StreamLocalBindUnlink = "yes"; };
}
