{ lib, fetchFromGitLab, buildGoPackage }:

buildGoPackage rec {
  pname = "quotesfilebot";
  version = "unstable-2021-05-24";

  goPackagePath = "gitlab.com/jrrobel/quotes-file-bot";
  src = fetchFromGitLab {
    owner = "jrrobel";
    repo = "quotes-file-bot";
    rev = "9a4023e63b958112ff12149c8bf78d2ba6e920c1";
    sha256 = "sha256-k2ShKJSl+T5I7EvTFTPBzTS7UVBRp2B+CkLzOUyLMYI=";
  };

  goDeps = ./deps.nix;
}
