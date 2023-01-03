{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-01-02";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "54565916875c8ec8e82dd2194a45c9d788e97220";
    sha256 = "sha256-1afJXW3dXcZMvRT98TsyMFMlDroFqPaxhEFnDpw6Mb4=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-NqGWHRJZ6QMui5XT8m3u2lyU29nQ4k30ZjUMqNizDEQ=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/discord";
    description = " A Matrix-Discord puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
