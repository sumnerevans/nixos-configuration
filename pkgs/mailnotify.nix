{ lib, pkgs, fetchFromGitHub }: with pkgs;
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

  src = /home/sumner/projects/mailnotify;
}
