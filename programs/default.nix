{ config, pkgs, lib, python38Packages, fetchFromGitHub, ... }:
{
  imports = [
    ./tmux.nix
    ./zsh.nix
  ];

  # Enable the GPG agent.
  programs.gnupg.agent.enable = true;

  # Enable the Network Manager applet
  programs.nm-applet.enable = true;

  # Automatically start an SSH agent.
  programs.ssh.startAgent = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    arc-icon-theme
    arc-theme
    aspell
    aspellDicts.en
    bash
    bat
    bitwarden
    bitwarden-cli
    brightnessctl
    chezmoi
    clang
    direnv
    discord
    dunst
    element-desktop
    elinks
    fd
    feh
    ffmpeg-full
    firefox
    flameshot
    fortune
    fzf
    gcc
    git
    gnumake
    google-chrome
    guvcview
    htop
    hugin
    i3status-rust
    iftop
    imagemagick
    inkscape
    isync
    jq
    kbdlight
    kdeconnect
    kdenlive
    khal
    kitty
    libnotify
    libreoffice-fresh
    light
    lxappearance
    mkpasswd
    mpv
    mumble
    mutt
    neovim
    nextcloud-client
    nodejs
    ocaml
    ocamlPackages.utop
    opam
    openssl
    pass
    pavucontrol
    picom
    pinentry
    playerctl
    poetry
    (python38.withPackages(ps: with ps; [
      dateutil
      fuzzywuzzy
      html2text
      icalendar
      pip
      pygobject3
      pynvim
      # python-gitlab
      pytz
      python-Levenshtein
      pytz
      vobject
      watchdog
    ]))
    # csmdirsearch
    ranger
    nodePackages.bash-language-server
    redshift
    remmina
    restic
    ripgrep
    rofi
    screenfetch
    screenkey
    scrot
    slack
    spotify
    steam
    wmctrl
    (sublime-music.override {
      chromecastSupport = true;
      serverSupport = true;
    })
    texlive.combined.scheme-full
    tree
    trickle
    unzip
    vale
    vdirsyncer
    vim
    vscode
    watchexec
    wget
    wireguard
    wireshark
    xclip
    xorg.xbacklight
    xorg.xdpyinfo
    xorg.xprop
    xournal
    yarn
    zathura
    zip
    zoom-us
  ];
}

