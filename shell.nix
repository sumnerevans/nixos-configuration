{ pkgs ? import <nixpkgs> {} }: with pkgs;
pkgs.mkShell {
  propagatedBuildInputs = with python3Packages; [
    gnutar
    nodePackages.bash-language-server
    openssl
    pass
    rnix-lsp
  ];

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;
}
