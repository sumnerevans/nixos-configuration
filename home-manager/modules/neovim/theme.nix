{ pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      vim-devicons
      edge
    ];

    extraLuaConfig = ''
      vim.g.edge_better_performance = 1
      vim.cmd("colorscheme edge")
      vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#888888', bg = 'NONE', italic = true })
    '';
  };
}
