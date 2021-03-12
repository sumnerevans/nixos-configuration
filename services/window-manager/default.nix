{ config, lib, pkgs, ... }: let
  editor = "${pkgs.neovim}/bin/nvim";
  terminal = "${pkgs.alacritty}/bin/alacritty";
in
{
  imports = [
    ./i3wm.nix
    ./sway.nix
  ];
}
