{ pkgs, ... }: let
  username = "sumner";
in
{
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}/Syncthing";
    configDir = "/home/${username}/.config/syncthing";
  };
}
