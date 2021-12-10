#
# Contains modules for configuring systems.
#
{ pkgs, ... }: {
  imports = [
    ./hardware
    ./programs
    ./services
    ./users

    ./beeper.nix
    ./nix.nix
    ./time.nix
  ];
}
