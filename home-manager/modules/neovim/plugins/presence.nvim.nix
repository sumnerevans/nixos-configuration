{ pkgs, ... }:
{
  programs.neovim.plugins = [
    {
      type = "lua";
      plugin = pkgs.vimPlugins.presence-nvim;
      config = ''
        require("presence").setup {}
      '';
    }
  ];
}
