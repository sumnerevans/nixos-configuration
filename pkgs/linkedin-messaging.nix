{ lib, fetchFromGitHub, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "linkedin-messaging";
  version = "0.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = "linkedin-messaging-api";
    rev = "v${version}";
    sha256 = "sha256-2AEFkbkenHQBW+QeBKQEbK4atq5Ij90D8uQimUolfA0=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    dataclasses-json
  ];

  pythonImportsCheck = [ "linkedin_messaging" ];

  meta = with lib; {
    description = "An unofficial API for interacting with LinkedIn Messaging.";
    homepage = "https://github.com/sumnerevans/linkedin-messaging-api";
    license = licenses.asl20;
    maintainers = [ maintainers.sumnerevans ];
  };
}
