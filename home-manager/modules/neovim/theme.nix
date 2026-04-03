{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-devicons
      edge
    ];

    extraConfig = ''
      let g:edge_better_performance = 1
      colorscheme edge

      highlight LspInlayHint ctermbg=0 cterm=italic guibg=transparent gui=italic
    '';
  };
}
