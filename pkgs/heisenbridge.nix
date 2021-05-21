{ lib, fetchFromGitHub, python3Packages }:
python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "unstable-2021-05-20";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = "heisenbridge";
    rev = "573b7f61d689715de7ff1bfdebf04686531c1793";
    sha256 = "sha256-lI7TylNIJ9yydRvEVgm7mvKeyOJltjuQHBdlyHKsxrg=";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    irc
    pyyaml
  ];

  checkInputs = [ python3Packages.pytestCheckHook ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
