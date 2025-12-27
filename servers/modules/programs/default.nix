{ pkgs, ... }: {
  imports = [ ./zsh.nix ];

  programs.htop.enable = true;

  environment.defaultPackages = with pkgs; [ jq vim ];
}
