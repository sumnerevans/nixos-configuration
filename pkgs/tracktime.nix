{ lib, pkgs }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.9.16";

  propagatedBuildInputs = with python38Packages; [
    argcomplete
    chromedriver
    docutils
    pass
    pdfkit
    pyyaml
    requests
    selenium
    tabulate
    wkhtmltopdf
  ];

  doCheck = false;

  src = python38.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "327d2de243ead6e66699e6e1f055298d5556087650c0b6da96f3c86f70589d29";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
