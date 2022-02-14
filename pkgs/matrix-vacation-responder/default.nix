{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "matrix-vacation-responder";
  version = "0.1.0";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/beeper/matrix-vacation-responder";
  src = fetchFromGitLab {
    owner = "beeper";
    repo = "matrix-vacation-responder";
    rev = "7bfa0d8ed6f2e88e6b7d0a76464063c400256293";
    sha256 = "sha256-1C+1uMq16DpqsTMZu3/QHqtSLi6rEMW4hCepA5vuvAc=";
  };

  goDeps = ./deps.nix;
}
