{ pkgs, ... }:
{
  imports = [ ./zsh.nix ];

  programs.htop.enable = true;

  environment.homeBinInPath = true;

  environment.defaultPackages = with pkgs; [
    jq
    vim
  ];
}
