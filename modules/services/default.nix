{ config, pkgs, ... }:
{
  imports = [
    ./autoupgrade.nix
    ./flatpak.nix
    ./gui
    ./sshd.nix
  ];
}
