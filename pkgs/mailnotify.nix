{ lib, pkgs, fetchFromGitHub }: with pkgs;
python38Packages.buildPythonApplication rec {
  nativeBuildInputs = [
    gobject-introspection
    python38Packages.setuptools
    wrapGAppsHook
  ];

  buildInputs = [
    libnotify
  ];

  propagatedBuildInputs = with python38Packages; [
    pygobject3
    watchdog
  ];

  doCheck = false;

  src = /home/sumner/bin/mailnotify.py;
}
