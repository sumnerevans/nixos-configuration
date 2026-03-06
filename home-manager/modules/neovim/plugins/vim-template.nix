# Sublime Text-like search
{ config, pkgs, ... }:
let
  vim-template = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-template";
    version = "unstable-2023-11-27";
    src = pkgs.fetchFromGitHub {
      owner = "aperezdc";
      repo = "vim-template";
      rev = "0bf607233719a0ed6e14bf0197ba8950bf8833fc";
      hash = "sha256-1/ec6ugaua0+KUwVITmUlx8r5IjvmeDmNEUm0OOQHa0=";
    };
    meta.homepage = "https://github.com/aperezdc/vim-template";
  };
in
{
  programs.neovim.plugins = [
    {
      plugin = vim-template;
      config = ''
        let g:templates_no_builtin_templates = 1
        let g:templates_directory = [
            \'${config.xdg.configHome}/nvim/templates',
            \]
      '';
    }
  ];
}
