let
  editor = "nvim";
in
{
  imports = [
    ./alacritty.nix
    ./browsers.nix
    ./communication.nix
    ./devtools.nix
    ./email
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./multimedia.nix
    ./neovim
    ./nix.nix
    ./newsboat.nix
    ./ssh.nix
    ./symlinks.nix
    ./syncthing.nix
    ./tmux.nix
    ./tracktime.nix
    ./udiskie.nix
    ./window-manager
    ./xdg.nix
    ./zsh
  ];

  home.sessionVariables = {
    COLORTERM = "truecolor";
    VISUAL = "${editor}";
    EDITOR = "${editor}";
  };
}
