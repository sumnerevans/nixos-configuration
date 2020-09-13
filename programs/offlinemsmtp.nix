{ lib, python38Packages, fetchFromGitHub }:
python38Packages.buildPythonApplication rec {
  pname = "offlinemsmtp";
  version = "0.3.6";

  propagatedBuildInputs = with python38Packages; [
    watchdog
    pygobject3
  ];

  doCheck = false;

  src = python38Packages.fetchPypi {
    inherit pname version;
    sha256 = "00cad2c775bbbfb894f21bf07598385f8852db4fe6f3e32c3ff8b36ae510182d";
  };

  meta = with lib; {
    description = "msmtp wrapper allowing for offline use";
    homepage = "https://git.sr.ht/~sumner/offlinemsmtp";
    license = licenses.gpl3Plus;
  };
}
