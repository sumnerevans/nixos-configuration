{ config, pkgs, ... }:
{
  # TODO move more things from the .zshrc?
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

    interactiveShellInit = ''
      # zsh-you-should-use
      source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
      export YSU_HARDCORE=1  # Force usage of aliases

      # zsh-completions and nix-zsh-completions
      fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)
      fpath=(${pkgs.nix-zsh-completions}/share/zsh/site-functions $fpath)
      source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh
    '';
  };
}
