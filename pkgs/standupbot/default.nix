{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.0";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "v${version}";
    sha256 = "sha256-XBnrs7yk+insROnoRcXTEy2+1qUUNK5S+Bo6uwCVCPI=";
  };

  goDeps = ./deps.nix;
}
