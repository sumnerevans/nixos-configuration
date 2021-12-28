{ lib, fetchFromGitHub, fetchpatch, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "heisenbridge";
  version = "1.8.3rc1";

  src = fetchFromGitHub {
    owner = "hifi";
    repo = pname;
    rev = "caf122a0f064b8bc2cd9fbd0f9ae703d323b7d04";
    sha256 = "sha256-JGb3Q5y24njPkyGnxxcoaBGPamNk3yJTkCcmrqgf610=";
  };

  postPatch = ''
    echo "${version}" > heisenbridge/version.txt
  '';

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    irc
    mautrix
    python-socks
    pyyaml
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/hifi/heisenbridge";
    license = licenses.mit;
    maintainers = [ maintainers.sumnerevans ];
  };
}
