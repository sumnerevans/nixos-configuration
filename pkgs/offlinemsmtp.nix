{ lib, pkgs, fetchFromGitHub }: with pkgs;
python38Packages.buildPythonApplication rec {
  pname = "offlinemsmtp";
  version = "0.3.8";

  nativeBuildInputs = [
    gobject-introspection
    python38Packages.setuptools
    wrapGAppsHook
  ];

  buildInputs = [
    libnotify
  ];

  propagatedBuildInputs = with python38Packages; [
    msmtp
    pass
    pygobject3
    watchdog
  ];

  doCheck = false;

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  src = python38.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "86a3747e51d61e08679532f24625d08f36de1084f0a6c1cec07675e6c4975b1a";
  };

  meta = with lib; {
    description = "msmtp wrapper allowing for offline use";
    homepage = "https://git.sr.ht/~sumner/offlinemsmtp";
    license = licenses.gpl3Plus;
  };
}
