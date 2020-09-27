{ lib, pkgs, fetchFromGitHub }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "offlinemsmtp";
  version = "0.3.7";

  propagatedBuildInputs = with python38Packages; [
    watchdog
    pygobject3
  ];

  doCheck = false;

  src = python38.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "30d27a2fb3619fde310ede40f977958b5c47c97f8b2ae09d9f6ec79f7447fc06";
  };

  meta = with lib; {
    description = "msmtp wrapper allowing for offline use";
    homepage = "https://git.sr.ht/~sumner/offlinemsmtp";
    license = licenses.gpl3Plus;
  };
}
