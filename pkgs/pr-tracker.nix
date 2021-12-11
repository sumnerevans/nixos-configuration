{ rustPlatform
, lib
, fetchFromGitHub
, openssl
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-tracker";
  version = "unstable-2021-12-11";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = pname;
    rev = "8fb42eecc5b6f6c5400340d70a35125a8b898217";
    sha256 = "sha256-Bqa+DubU57Qj1boaazL97V7kWdmViY6OtYmlnSNusBw=";
  };

  cargoSha256 = "sha256-HeZKjn5okHQumZcUXVevb/YpDEkqAUzD1ApnSgdWReE=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl systemd ];

  meta = with lib; {
    description = "Nixpkgs pull request channel tracker";
    longDescription = ''
      A web server that displays the path a Nixpkgs pull request will take
      through the various release channels.
    '';
    platforms = platforms.linux;
    homepage = "https://git.qyliss.net/pr-tracker";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
