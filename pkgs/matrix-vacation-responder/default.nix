{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "matrix-vacation-responder";
  version = "0.1.0";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/matrix-vacation-responder";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "matrix-vacation-responder";
    rev = "75609dd66d2968f8719ff07f23843fbadb2aa9c8";
    sha256 = "sha256-+YWNQ+K5ATWP/zofNEG0aCMtbQTQWAu/vH29HfLP7xk=";
  };

  goDeps = ./deps.nix;
}
