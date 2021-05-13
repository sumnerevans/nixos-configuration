#
# Contains modules for configuring systems.
#
{ pkgs, ... }: {
  imports = [
    ./hardware
    ./programs
    ./services

    ./fonts.nix
    ./nix.nix
    ./time.nix
  ];
}
