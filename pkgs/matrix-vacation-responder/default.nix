{ lib, fetchFromGitLab, buildGoPackage, olm }:

buildGoPackage rec {
  pname = "matrix-vacation-responder";
  version = "0.1.0";

  buildInputs = [ olm ];

  goPackagePath = "gitlab.com/beeper/matrix-vacation-responder";
  src = fetchFromGitLab {
    owner = "beeper";
    repo = "matrix-vacation-responder";
    rev = "bf85b81a3e9f7011229b7ee1ff7f1152ccb9be77";
    sha256 = "sha256-+jKVYMSUGiHug473OgS75zpEYEfas73S23VbUyaVOBU=";
  };

  goDeps = ./deps.nix;
}
