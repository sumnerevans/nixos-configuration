{ lib, fetchFromGitHub, python3Packages }:
python3Packages.buildPythonPackage rec {
  pname = "heisenbridge";
  version = "unstable-2021-05-20";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = "heisenbridge";
    rev = "2715a51737c63c34ba04177242fd92af9f7834a5";
    sha256 = "sha256-C69QoQHbUw9XqjpsAD8HgrY7E3RTgCfkQjQhwcDLqiY=";
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
