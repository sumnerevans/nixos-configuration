{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.2.3";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "v${version}";
    sha256 = "sha256-mB5COJueX1IZvdyVUjK4JT+LL4ZGQ0Q3goIDxTqkbEE=";
  };

  goDeps = ./deps.nix;
}
