{ lib, pkgs, fetchFromGitHub }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "offlinemsmtp";
  version = "0.3.7";

  nativeBuildInputs = [
    gobject-introspection
    python38Packages.setuptools
    wrapGAppsHook
  ];

  buildInputs = [
    libnotify
  ];

  propagatedBuildInputs = with python38Packages; [
    watchdog
    pygobject3
  ];

  doCheck = false;

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

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
