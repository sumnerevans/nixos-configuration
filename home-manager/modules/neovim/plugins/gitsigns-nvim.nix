{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      type = "lua";
      plugin = pkgs.vimPlugins.gitsigns-nvim;
      config = ''
        require('gitsigns').setup {}
      '';
    }
  ];
}
