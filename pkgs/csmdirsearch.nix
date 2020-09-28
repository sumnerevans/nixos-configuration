{ lib, pkgs, fetchFromGitHub }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "csmdirsearch";
  version = "0.1.1";

  propagatedBuildInputs = with python38Packages; [
    beautifulsoup4
    requests
  ];

  doCheck = false;

  src = python38.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "b44539ab0fbd135aade9c99d9c0c4508870cafd4fcec70a01a1c760a5731a760";
  };

  meta = with lib; {
    description = "A convinient Python CLI interface to the Colorado School of Mines DirSearch website.";
    homepage = "https://github.com/jackrosenthal/csmdirsearch";
    license = licenses.mit;
  };
}
