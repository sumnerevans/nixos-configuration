{ pkgs, ... }:
{
  programs.zsh = {
    initContent = ''
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
      source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
      fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
      fpath+=(${pkgs.nix-zsh-completions}/share/zsh/site-functions)
      source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh
    '';

    sessionVariables = {
      YSU_HARDCORE = 1; # Force usage of aliases
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=8";
      ZSH_AUTOSUGGEST_STRATEGY = [ "match_prev_cmd" ];
      ZSH_AUTOSUGGEST_USE_ASYNC = "1";
    };
  };
}
