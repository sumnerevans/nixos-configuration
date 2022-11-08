{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-12-14";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "824b70e27afec3c3d7ccaf1b8b5f27e22e25a8c6";
    sha256 = "sha256-/DFkCt8MVeXC2zR3g1fUBR6NQy4lpvP+NIHImXJv+Ls=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-PTOLK3S9NaUn2Ofwahyeg4Vv43766kl+mUHT/3LmhRc=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/discord";
    description = " A Matrix-Discord puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
