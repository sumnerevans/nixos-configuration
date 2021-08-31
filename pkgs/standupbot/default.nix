{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.2.6";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "v${version}";
    sha256 = "sha256-bjmhHLuQ4LvMDm8dEjMFhdiZC+vWqVlNUoE5dftrD/8=";
  };

  goDeps = ./deps.nix;
}
