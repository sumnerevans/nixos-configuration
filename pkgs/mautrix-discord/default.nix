{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-01-11";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "de59f449f1c68e51d114242c622ddea4f6586d6e";
    sha256 = "sha256-p9l2MFqvrKIvKBT5hM299qv2hoDrpBMrefFOZqE9rT4=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-VZD+gQv9YsyV7De2A+3/p/LrXJeY2pJKACUy9q8/X3s=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/discord";
    description = " A Matrix-Discord puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
