{ lib, pkgs, fetchFromGitHub }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.9.15";

  propagatedBuildInputs = with python38Packages; [
    argcomplete
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
    sha256 = "efc418d33fe31e33556f74b3d0df6146be60d975ba3f567d79a14d44994a8042";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
