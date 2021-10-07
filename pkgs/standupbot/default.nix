{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.3.1rc3";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "5f380a7264ba257b007921f4d5f9a30f910a553a";
    sha256 = "sha256-oNSoaTZzg8WryeSnOw2JQ6Hxke5TSzMOS7uJM0v44iA=";
  };

  goDeps = ./deps.nix;
}
