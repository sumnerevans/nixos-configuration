{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-01-28";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "69268f8d927b11c40ca6784a880d6a6c3a6d59f2";
    sha256 = "sha256-gHhEhtyLGaSnFOiFupI1otO+B+0FYrVvUD9yDks0Pgg=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-KUI5nIeI+QsizDSITxyyPT0fULwBaOgB4bkQDivZ5kU=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/discord";
    description = " A Matrix-Discord puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
