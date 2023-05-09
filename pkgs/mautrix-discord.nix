{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2023-05-08";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "7655ff1a648e6312203623ff4bcc3ab85653cc18";
    sha256 = "sha256-SBLP3fvx3C6fSDB61VU0D8nhAy3U0OcV2qELG926xP0=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-4K/FjeEbsM7cHfx7WGcsCUVKL1bT2qLDBkST1Fp9KNU=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/discord";
    description = " A Matrix-Discord puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
