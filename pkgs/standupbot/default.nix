{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.1rc1";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "6866b5dd4b62e389ae18dc4cd81186879210a753";
    sha256 = "sha256-0ClJA2+KhoPwRwE2fCxVnhQjAd9fo+IKbbN9mTMz35E=";
  };

  goDeps = ./deps.nix;
}
