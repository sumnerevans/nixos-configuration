{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "msclinkbot";
  version = "unstable-2022-04-28";

  src = fetchFromGitHub {
    owner = "beeper";
    repo = "msc-link-bot";
    rev = "47701aa82ac6296efddf6222d94eb3b4644a9818";
    sha256 = "sha256-8BXQhDkynIL29O4hn7/G8ueiW1WO+AAAAAAAXYL9Aow=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-KUI5nIeI+QsizDSITxAAAAAAAAwBaOgB4bkQDivZ5kU=";

  meta = with lib; {
    homepage = "https://git.hnitbjorg.xyz/~edwargix/msc-link-bot";
    description = "A re-write of @msclinkbot:matrix.org with support for encrypted rooms.";
    license = licenses.mit;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
