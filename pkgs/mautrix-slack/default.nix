{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-slack";
  version = "unstable-2023-01-10";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "f933a14343ad3bef3059bf64eec02f8a34d81461";
    sha256 = "sha256-TK6VjQYX2s6hqCP5jJimWFYAjjGCfGRCgtaEDlhcznE=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-apGwxV5EugZAJSIbvjmX8cdrcA/c+XEoe/gxB5nhDzU=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/slack";
    description = " A Matrix-Slack puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
