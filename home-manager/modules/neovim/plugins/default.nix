{ pkgs, ... }:
{
  imports = [
    # Project Navigation
    ./gitlinker.nix
    ./telescope.nix

    # Local Environment Configuration and Integration
    ./vim-autoswap.nix
    ./vim-localvimrc.nix
    ./vim-rooter.nix
    ./vim-tmux-navigator.nix

    # UI Chrome
    ./barbar.nix
    ./blamer.nix
    ./gitsigns-nvim.nix
    ./nvim-tree-lua.nix

    # Editor
    ./copilot.nix
    ./vim-template.nix

    # Language Server, Completion, and Formatting
    ./conform.nvim.nix
    ./lsp.nix
    ./nvim-cmp.nix
    ./trouble.nvim.nix
    ./typst-preview.nix

    # Synatx Highlighting
    ./rainbow-delimiters.nix
    ./tree-sitter.nix

    # LOLs
    ./presence.nvim.nix
  ];

  programs.neovim.plugins = [
    # Local Environment Configuration and Integration
    pkgs.vimPlugins.direnv-vim

    # Editor
    pkgs.vimPlugins.vim-closetag
    pkgs.vimPlugins.vim-surround
    pkgs.vimPlugins.vim-tmux-clipboard
    pkgs.vimPlugins.vim-visual-multi
  ];
}
