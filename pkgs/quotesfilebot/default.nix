{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "quotesfilebot";
  version = "0.1.1";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/jrrobel/quotes-file-bot";
  src = fetchFromGitLab {
    owner = "jrrobel";
    repo = "quotes-file-bot";
    rev = "v${version}";
    sha256 = "sha256-M939+UXDOXGrTEHrg/NnbjEFT2ZGVMtklonlK6gbEgo=";
  };

  goDeps = ./deps.nix;
}
