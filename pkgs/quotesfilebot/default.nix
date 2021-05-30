{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "quotesfilebot";
  version = "0.1.0";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/jrrobel/quotes-file-bot";
  src = fetchFromGitLab {
    owner = "jrrobel";
    repo = "quotes-file-bot";
    rev = "v0.1.0";
    sha256 = "sha256-jXQYfXwkaExwmDmUIonzvYqq6Fi3sDCQO3lnPFcpboE=";
  };

  goDeps = ./deps.nix;
}
