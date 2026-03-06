{ pkgs, ... }:
{
  nix.package = pkgs.nix;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    allowUnfree = true;
    android_sdk.accept_license = true;
  };
}
