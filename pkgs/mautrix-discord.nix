{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-04-12";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "a7095b1bd45d54c57ac3b57104dd5933f9b91e19";
    sha256 = "sha256-8BXQhDkynIL29O4hn7/G8ueiW1WO+sYoqtWXXYL9Aow=";
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
