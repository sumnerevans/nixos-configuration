{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "quotesfilebot";
  version = "0.1.3";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/jrrobel/quotes-file-bot";
  src = fetchFromGitLab {
    owner = "jrrobel";
    repo = "quotes-file-bot";
    rev = "v${version}";
    sha256 = "sha256-pEVp4pVGeatNnuL0RP0AX0mbfUa2zRcq2FETzMzoWpA=";
  };

  goDeps = ./deps.nix;
}
