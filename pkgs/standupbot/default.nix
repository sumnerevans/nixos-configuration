{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.1rc4";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/beeper/standupbot";
  src = fetchFromGitLab {
    owner = "beeper";
    repo = "standupbot";
    rev = "a6b1e4e175ca12fc1f801475b8e470e9537590f3";
    sha256 = "sha256-TzjIjf82tfThMEXRefeOLhYrS7JXjHH2AI4nQWU7lI4=";
  };

  goDeps = ./deps.nix;
}
