{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-devicons
      edge
    ];

    extraConfig = ''
      autocmd OptionSet background

      let g:edge_better_performance = 1
      colorscheme edge

      highlight LspInlayHint ctermbg=0 cterm=italic guibg=transparent gui=italic
    '';
  };
}
