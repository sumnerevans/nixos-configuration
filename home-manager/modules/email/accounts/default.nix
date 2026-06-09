{ config, ... }:
{
  imports = [
    ./admin-accounts.nix
    ./nevarro.nix
    ./personal.nix
  ];

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/Mail";
}
