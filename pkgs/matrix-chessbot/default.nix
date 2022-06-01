{ lib, fetchFromGitHub, buildGoPackage, olm, imagemagick }:

buildGoPackage rec {
  pname = "matrix-chessbot";
  version = "0.1.0";

  buildInputs = [
    olm
  ];

  propagatedBuildInputs = [
    imagemagick
  ];

  goPackagePath = "github.com/sumnerevans/matrix-chessbot";
  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = "matrix-chessbot";
    rev = "4e17302c457ef02aa655876039cdd8b870c807d4";
    sha256 = "sha256-i7xyUg7m28xO0OzQhqx9TZNytTxUTS3av8tfto4NKOQ=";
  };

  goDeps = ./deps.nix;
}
