{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.2.1";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "v${version}";
    sha256 = "sha256-/LzmmlfTK7SHVjsgsmcqSDRWmd69bUzXXX6Em1gbL+Y=";
  };

  goDeps = ./deps.nix;
}
