{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.1rc2";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "28b03aa14d0d0b0864334174e962c8fe28d4083c";
    sha256 = "sha256-bLiEHY+XuVyOgu7MyrJa+H59zBeEG/Xt3dvawV7SbY8=";
  };

  goDeps = ./deps.nix;
}
