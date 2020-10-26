{ fetchgit, pkgs }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "mailnotify";
  version = "0.0.1";

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

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  doCheck = false;

  src = fetchgit {
    url = "https://git.sr.ht/~sumner/mailnotify";
    rev = "1158ee1";
    sha256 = "1dw1vai6pnga7fkqzksis10yasjiqqsjls6g1mybyn8q9m8jxksn";
  };
}
