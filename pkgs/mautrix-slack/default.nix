{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-slack";
  version = "unstable-2023-01-23";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "56277589a08ae3b6aa335244a696911b05278ac2";
    sha256 = "sha256-5TvqOA9uQZtzvkp7gKINI73S1Gtsxw/3T6mRO+0/me4=";
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
