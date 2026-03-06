{ pkgs, ... }:
{
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = typst-preview-nvim;
      type = "lua";
      config = ''
        require 'typst-preview'.setup()
      '';
    }
  ];
}
