# Cool other configs to look at
# - http://www.lukesmith.xyz/conf/.vimrc
# - https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
# - https://github.com/jschomay/.vim/blob/master/vimrc
# - https://github.com/jhgarner/DotFiles
#
# Dependencies
# - bat
# - python-neovim
# - ripgrep
# - wmctrl
# - probably others

{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ./clipboard.nix
    ./plugins
    ./shortcuts.nix
    ./theme.nix
  ];

  programs.neovim = {
    enable = true;
    extraConfig = concatMapStringsSep "\n\n" builtins.readFile [
      ./init.vim
      ./filetype-specific-configs.vim
    ];

    extraPackages = with pkgs; [
      bat
      ripgrep
      texlab
    ];

    extraPython3Packages = (
      ps: with ps; [
        pynvim
        setuptools
      ]
    );

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  home.symlinks."${config.xdg.configHome}/nvim/spell/en.utf-8.add" =
    "${config.home.homeDirectory}/Syncthing/.config/nvim/spell/en.utf-8.add";
}
