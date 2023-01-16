{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-01-16";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "315e7921e6c2f82e7c0fa12fea94edb245844e3a";
    sha256 = "sha256-+GRvMIDAk+3uhDa3jSYHvV5NC+nRYukvhNh5zUYT3Ls=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-DVztldaw+UtmJ2tmpsNAYBORWJFs4GuplXiDjJqBsg0=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/discord";
    description = " A Matrix-Discord puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
