{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-slack";
  version = "unstable-2023-01-16";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "6d3f66157904e4a5c1b0ec1452016862d898f18d";
    sha256 = "sha256-Ysl7u6YRqoEkB+JnutPAtYChQDHruiNT3HB31LlUxqA=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-kYaeVXxrfA8WuL10+2DC6c2cYJ2li4/3ulKxcy/KviQ=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/slack";
    description = " A Matrix-Slack puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
