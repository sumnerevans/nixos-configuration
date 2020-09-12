{ config, pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    arc-theme
    arc-icon-theme
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
    elinks
    element-desktop
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
    gnupg
    google-chrome
    i3status-rust
    iftop
    imagemagick
    inkscape
    isync
    jq
    kitty
    kdeconnect
    khal
    libnotify
    libreoffice-fresh
    lxappearance
    mpv
    mutt
    mumble
    neovim
    networkmanagerapplet
    nextcloud-client
    nodejs
    ocaml
    opam
    ocamlPackages.utop
    openssl
    pass
    pavucontrol
    picom
    pinentry
    (python38.withPackages(ps: with ps; [
      dateutil
      fuzzywuzzy
      goobook
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
    redshift
    wmctrl
    # csmdirsearch
    restic
    remmina
    ripgrep
    rofi
    scrot
    spotify
    steam
    slack
    (sublime-music.override {
      chromecastSupport = true;
      keyringSupport = true;
      networkSupport = true;
      notifySupport = true;
      serverSupport = true;
    })
    texlive.combined.scheme-full
    tmux
    tree
    trickle
    unzip
    vdirsyncer
    vim
    vscode
    wget
    wireshark
    xbindkeys
    xorg.xprop
    xorg.xdpyinfo
    zathura
    zip
    zoom-us
  ];
}

