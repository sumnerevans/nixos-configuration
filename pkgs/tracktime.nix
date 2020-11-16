{ lib, pkgs }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.9.18";

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
    sha256 = "a083b336945ce208d28173cf240b89b8e9adfceb145dfe82744c0ebef966cc99";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://git.sr.ht/~sumner/tracktime";
    license = licenses.gpl3Plus;
  };
}
