{ lib, fetchFromGitHub, python3 }:

with python3.pkgs;

buildPythonPackage rec {
  pname = "linkedin-messaging";
  version = "0.4.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = "linkedin-messaging-api";
    rev = "v${version}";
    sha256 = "sha256-o5MNb3lVTEVLQY2s3oyh0cqnXwnei703if5C+o+QYBQ=";
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

