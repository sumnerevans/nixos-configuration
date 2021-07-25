{ lib, fetchFromSourcehut, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.1.5";

  buildInputs = [ olm ];

  goPackagePath = "git.sr.ht/~sumner/standupbot";
  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = "standupbot";
    rev = "v${version}";
    sha256 = "sha256-lP/YCwaJKvTiATY0YQO7vrMkRWlzFGIjEE/X0ePJt7U=";
  };

  goDeps = ./deps.nix;
}
