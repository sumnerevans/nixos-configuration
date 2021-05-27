{ lib, fetchFromGitLab, buildGoPackage }:

buildGoPackage rec {
  pname = "quotesfilebot";
  version = "unstable-2021-05-26";

  goPackagePath = "gitlab.com/jrrobel/quotes-file-bot";
  src = fetchFromGitLab {
    owner = "jrrobel";
    repo = "quotes-file-bot";
    rev = "f0095d18eab3dbdfb23ce2798eada2c1543b3215";
    sha256 = "sha256-u25qoJhCcladvFcs8rpzaP8HWw/IVzsA//LfoN+xngE=";
  };

  goDeps = ./deps.nix;
}
