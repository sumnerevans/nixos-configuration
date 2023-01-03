{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-slack";
  version = "unstable-2023-01-02";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "26d8b797fa76ca23426c9bd71f5475d42e74c749";
    sha256 = "sha256-5sVLoYLFhQDIs6SBcSIQg6mz26k70vL6mh8XbaETXoY=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-AJp4t7OEPCmT8+O17naQJu94QR/afnYEyz7JrtLy5lE=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/slack";
    description = " A Matrix-Slack puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
