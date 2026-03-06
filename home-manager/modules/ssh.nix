{ config, ... }:
let
  homedir = config.home.homeDirectory;
in
{
  home.symlinks."${homedir}/.ssh/config" = "${homedir}/Syncthing/.ssh/config";

  services.ssh-agent.enable = true;
}
