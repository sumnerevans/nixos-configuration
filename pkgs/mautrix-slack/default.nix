{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-slack";
  version = "unstable-2023-03-20";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "858eea6e25e708fd490348b631ccfa5b6391b997";
    sha256 = "sha256-kA2IzYkvWoh/LxykuSzOLif76ZDbj7hKRjdIGDHY1W0=";
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
