{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.1rc5";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/beeper/standupbot";
  src = fetchFromGitLab {
    owner = "beeper";
    repo = "standupbot";
    rev = "75d45d5b508559918f53a398e5f0763aa80481f4";
    sha256 = "sha256-w1OTNye/0jMV0hjr3ogfJN8gSRsHwwQNikxpXzzVx+Q=";
  };

  goDeps = ./deps.nix;
}
