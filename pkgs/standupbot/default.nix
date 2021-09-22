{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.3.1rc2";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "bfd423d948608489a8c538083a70550fd82834d1";
    sha256 = "sha256-a7sFFIAfYSkmoZm8i8w/x24+jq3RtaHoMP+YjIxlUDw=";
  };

  goDeps = ./deps.nix;
}
