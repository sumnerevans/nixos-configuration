# Swap to the already opened file
{ pkgs, ... }:
with pkgs;
{
  programs.neovim = {
    extraPackages = [ wmctrl ];
    plugins = [
      {
        type = "viml";
        plugin = vimPlugins.vim-autoswap;
        config = ''
          let g:autoswap_detect_tmux = 1
        '';
      }
    ];
  };
}
