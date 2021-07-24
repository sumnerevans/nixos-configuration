{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.1.1";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "v${version}";
    sha256 = "sha256-B8qFNiDxwU+edzUnbmxKA4MuLRbJNC3hbRffBGJu/Nk=";
  };

  goDeps = ./deps.nix;
}
