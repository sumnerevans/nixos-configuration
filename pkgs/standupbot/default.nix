{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.2.4";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "v${version}";
    sha256 = "sha256-DSxwdk4nRlRVd+ckGP5ogpVC1/QuOc/bj7pAYtei7Cw=";
  };

  goDeps = ./deps.nix;
}
