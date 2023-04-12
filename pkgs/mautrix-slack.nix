{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-slack";
  version = "unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "677f3bc54c78634d278f49f0e3292deeb769edbb";
    sha256 = "sha256-wdKzpM+f8qqYv8Q1B3614/ICwDNLa6IqE0N/bpUzdq0=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-0IL0C+c/yZh1OxzNcrzmhF5qUagLzQImygTa4DQunio=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/slack";
    description = " A Matrix-Slack puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
