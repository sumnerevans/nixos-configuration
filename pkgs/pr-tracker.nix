{ rustPlatform
, lib
, fetchFromSourcehut
, openssl
, pkg-config
, systemd
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-tracker";
  version = "unstable-2021-05-21";

  src = fetchFromSourcehut {
    owner = "~sumner";
    repo = pname;
    rev = "8f5bcddd8523403dc55dbb4056336369d9e497b2";
    sha256 = "sha256-EA8IW9qbjpIzpB3xl9DW1xw2gBtUBUO0/YIGvuBQcu0=";
  };

  cargoSha256 = "sha256-7i+h4Q5Gj3VD25Kz/B/gT/u5MXuE8G7Ghd7QUIyADpA=";

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
    license = licenses.mit;
    maintainers = with maintainers; [ sumnerevans ];
  };
}
