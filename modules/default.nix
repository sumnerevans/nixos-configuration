# Contains modules for configuring systems.
#
{
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
