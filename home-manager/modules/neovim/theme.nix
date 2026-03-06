{ pkgs, lib, ... }:
with lib;
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-devicons
      nightfox-nvim
    ];

    extraConfig = ''
      colorscheme carbonfox
      set background=dark

      highlight LspInlayHint ctermbg=0 cterm=italic guibg=transparent gui=italic
    '';
  };
}
