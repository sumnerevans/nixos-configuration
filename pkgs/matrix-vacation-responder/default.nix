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
    sha256 = "sha256-OKHTfjQ7bNVN4Hw91sPGEv9JPEhgdtB9TTl19/pA5ow=";
  };

  goDeps = ./deps.nix;
}
