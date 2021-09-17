{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.3.1rc1";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "7236338e5f0cc9fe56730b89d299dddd688f977a";
    sha256 = "sha256-w1aqBTlin3aS2feiNPlN1riZU+cBJGDXsfR6suVx9vg=";
  };

  goDeps = ./deps.nix;
}
