{ config, lib, pkgs, ... }: let
  editor = "${pkgs.neovim}/bin/nvim";
  terminal = "${pkgs.alacritty}/bin/alacritty";
in
{
  imports = [
    ./i3wm.nix
    ./sway.nix
  ];

  # Add some environment variables for when things get fired up with shortcuts
  # in i3/sway.
  environment.variables = {
    VISUAL = "${editor}";
    EDITOR = "${editor}";
    TERMINAL = "${terminal}";
  };

  # Must have this for redshift or gammastep.
  location.provider = "geoclue2";
}
