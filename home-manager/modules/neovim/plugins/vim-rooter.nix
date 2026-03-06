# Always change the CWD to the project root.
{ lib, pkgs, ... }:
let
  rooter_patterns = [
    ".rooter_root"
    ".git"
  ];
in
{
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.vim-rooter;
      config = ''
        let g:rooter_patterns = [${lib.concatMapStringsSep ", " (p: "'${p}'") rooter_patterns}]
      '';
    }
  ];
}
