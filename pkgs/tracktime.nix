{ lib, pkgs, fetchFromGitHub }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.9.14";

  propagatedBuildInputs = with python38Packages; [
    argcomplete
    tabulate
    pdfkit
    docutils
    requests
    pyyaml
  ];

  doCheck = false;

  src = python38.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0db331225420d47c283f40a7a3f2aa8c93706bda16440e79e62c8b34e18acd7e";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
