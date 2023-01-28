{ lib, fetchFromGitHub, buildGoModule, olm }:

buildGoModule rec {
  pname = "mautrix-discord";
  version = "unstable-2022-01-28";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "discord";
    rev = "9cf9d7c446accb44c99e257dd3296da530065012";
    sha256 = "sha256-cK3v6LknYIU/x6/FQnvcljPN+q0UT0dwxZ/DKpbeD2g=";
  };

  buildInputs = [ olm ];

  vendorSha256 = "sha256-MSGQdP7cZUt4yEhcfxH+3azz8zFozILjgLT6upCSBDU=";

  meta = with lib; {
    homepage = "https://github.com/mautrix/discord";
    description = " A Matrix-Discord puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
