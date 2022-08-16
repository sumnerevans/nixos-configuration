{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "standupbot";
  version = "0.4.1rc6";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/beeper/standupbot";
  src = fetchFromGitLab {
    owner = "beeper";
    repo = "standupbot";
    rev = "491d6451b448f821a1bb0e0bb62ceeaf20a7ccf8";
    sha256 = "sha256-xHB5euBeNmvF1igSR+9FUYuucX8JKZaI6xgU5ZDjXnc=";
  };

  goDeps = ./deps.nix;
}
