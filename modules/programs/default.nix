{ pkgs, ... }: {
  imports = [ ./tmux.nix ];

  # Environment variables
  environment.homeBinInPath = true;

  # Minimal package set to install on all machines.
  environment.systemPackages = with pkgs; [
    bind
    direnv
    fd
    git
    git-crypt
    gnupg
    htop
    iftop
    inetutils
    lm_sensors
    mtr
    neovim
    nix-direnv
    openssl
    restic
    ripgrep
    rsync
    sysstat
    tmux
    tree
    unzip
    vim
    wireguard-tools
    zsh
  ];

  # Enable ZSH for the command-not-found functionality
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
}
