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
    rev = "f9a8e247f47da1b5fd51e76816d36302fbd46a89";
    sha256 = "sha256-lg3lw9PhvcNWGYEEaVJwwIt80QR3DvDcy4RXdLeuvh4=";
  };

  goDeps = ./deps.nix;
}
