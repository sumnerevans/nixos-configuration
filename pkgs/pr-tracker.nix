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
    rev = "60c48d1d94ee335e8eae94a2f8e0863ebbe52b19";
    sha256 = "sha256-xTankNu6MlBx9oBd8F4I4IoWFXNoiyuPvCJtSLpxlFI=";
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
