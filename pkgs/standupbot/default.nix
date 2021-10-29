{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.1rc4";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "8a49a24814806d3bf56120c5207abf5f48a18543";
    sha256 = "sha256-+YWNQ+K5ATWP/zofNEG0aCMtbQTQWJu/vH29HfLP7xk=";
  };

  goDeps = ./deps.nix;
}
