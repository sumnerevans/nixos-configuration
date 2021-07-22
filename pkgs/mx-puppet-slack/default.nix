{ stdenv, fetchFromGitHub, pkgs, lib, nodejs, nodePackages, pkg-config, libjpeg
, pixman, cairo, pango }:

let
  # No official version ever released
  src = fetchFromGitHub {
    owner = "Sorunome";
    repo = "mx-puppet-slack";
    rev = "3b0638be2093d531739b7b8fe234fe4b54c61b7d";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  myNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in myNodePackages.package.override {
  pname = "mx-puppet-slack";

  inherit src;

  nativeBuildInputs = [ nodePackages.node-pre-gyp pkg-config ];
  buildInputs = [ libjpeg pixman cairo pango ];

  postInstall = ''
    # Patch shebangs in node_modules, otherwise the webpack build fails with interpreter problems
    patchShebangs --build "$out/lib/node_modules/mx-puppet-slack/node_modules/"
    # compile Typescript sources
    npm run build

    # Make an executable to run the server
    mkdir -p $out/bin
    cat <<EOF > $out/bin/mx-puppet-slack
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/node_modules/mx-puppet-slack/build/index.js "\$@"
    EOF
    chmod +x $out/bin/mx-puppet-slack
  '';

  meta = with lib; {
    description = "A Slack puppeting bridge for Matrix";
    license = licenses.asl20;
    homepage = "https://github.com/Sorunome/mx-puppet-slack";
    maintainers = with maintainers; [ sumnerevans ];
    platforms = platforms.unix;
  };
}
