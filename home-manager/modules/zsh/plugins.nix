{ pkgs, ... }:
{
  # compinit runs in the NixOS-level /etc/zshrc, before .zshrc, so the
  # completions need to be on the profile's $fpath.
  home.packages = [ pkgs.zsh-completions ];

  programs.zsh = {
    initContent = ''
      source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
    '';

    autosuggestion.highlight = "fg=8";

    sessionVariables = {
      YSU_HARDCORE = 1; # Force usage of aliases
    };
  };
}
