{ config, pkgs, ... }:
{
  imports = [
    ./clipmenu.nix
    ./picom.nix
    ./window-manager.nix
  ];

  # List services that you want to enable:
  services.lorri.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [32];

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
