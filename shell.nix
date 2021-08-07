{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  propagatedBuildInputs = with pkgs; [
    git-crypt
    gnutar
    nodePackages.bash-language-server
    openssl
    pass
    rnix-lsp

    (
      python3.withPackages (
        ps: with ps; [
          digital-ocean
          flake8
          jedi
          pynvim
          yapf
        ]
      )
    )
  ];
}
