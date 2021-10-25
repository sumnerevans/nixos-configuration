{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.1rc3";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "ea60d9b796ee8f0e3b288160e725ffb31ff20ecd";
    sha256 = "sha256-xrggcgncKNHKHySERLTrBE2QiycwmnPw3FVdPoyW/zA=";
  };

  goDeps = ./deps.nix;
}
