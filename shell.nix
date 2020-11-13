{ pkgs ? import <nixpkgs> {} }: with pkgs;
pkgs.mkShell {
  propagatedBuildInputs = with python3Packages; [
    gnutar
    nodePackages.bash-language-server
    openssl
    pass
    rnix-lsp
  ];
}
