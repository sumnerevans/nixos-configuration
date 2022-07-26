{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.1rc6";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/beeper/standupbot";
  src = fetchFromGitLab {
    owner = "beeper";
    repo = "standupbot";
    rev = "e9291ef6dbf668668a883675a07ef85584c3fe65";
    sha256 = "sha256-MUQ18xa2d+NasiDFkwPnkQdmGi47GBFI6923zRnlugI=";
  };

  goDeps = ./deps.nix;
}
