# Contains modules for configuring systems.
#
{
  imports = [
    ./hardware
    ./programs
    ./services
    ./users

    ./nix.nix
    ./time.nix
  ];
}
