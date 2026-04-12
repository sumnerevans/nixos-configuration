{ config, pkgs, ... }:
with pkgs;
{
  programs.neovim.plugins = [
    {
      type = "viml";
      plugin = vimPlugins.vim-localvimrc;
      config = ''
        let g:localvimrc_persistent = 2
        let g:localvimrc_persistence_file = "${config.xdg.configHome}/nvim/localvimrc_persistent"
      '';
    }
  ];
}
