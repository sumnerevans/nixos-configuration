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
    ./vim-lightline.nix
    ./nvim-tree-lua.nix

    # Editor
    ./copilot.nix
    # ./nvim-neoclip.nix
    ./vim-template.nix

    # Language Server, Completion, and Formatting
    ./conform.nvim.nix
    ./nvim-cmp.nix
    ./nvim-lspconfig.nix
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
