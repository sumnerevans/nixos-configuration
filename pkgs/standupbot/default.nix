{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.2.7";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "v${version}";
    sha256 = "sha256-ZEpHkvL8HdBPgspWydUtC6XQdSY8jF3gtGhWukyOtxU=";
  };

  goDeps = ./deps.nix;
}
