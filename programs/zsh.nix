{ config, pkgs, ... }:
{
  # TODO move more things from the .zshrc
  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
      strategy = "match_prev_cmd";
      extraConfig = {
        ZSH_AUTOSUGGEST_USE_ASYNC = "1";
      };
    };
    syntaxHighlighting.enable = true;
  };
}
