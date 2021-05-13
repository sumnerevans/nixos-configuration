#
# Contains modules for configuring systems.
#
{ pkgs, ... }: {
  imports = [
    ./hardware
    ./programs
    ./services
    ./users

    ./nix.nix
    ./time.nix
  ];
}
