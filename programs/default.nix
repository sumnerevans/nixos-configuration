{ config, pkgs, lib, python38Packages, fetchFromGitHub, ... }:
{
  imports = [
    ./direnv.nix
    ./tmux.nix
    ./zsh.nix
  ];

  # Enable the GPG agent.
  programs.gnupg.agent.enable = true;

  # Automatically start an SSH agent.
  programs.ssh.startAgent = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;

  # Allow spidermonkey-38
  nixpkgs.config.permittedInsecurePackages = [
    "spidermonkey-38.8.0"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let
    csmdirsearch = callPackage ../pkgs/csmdirsearch.nix {};
    offlinemsmtp = callPackage ../pkgs/offlinemsmtp.nix {};
    python-csmdirsearch = callPackage ../pkgs/python-csmdirsearch.nix {};
    python-gitlab = callPackage ../pkgs/python-gitlab.nix {};
    sublime-music-tmp = callPackage ../pkgs/sublime-music.nix {};
    tracktime = callPackage ../pkgs/tracktime.nix {};
  in
    [
      (
        python38.withPackages (
          ps: with ps; [
            dateutil
            fuzzywuzzy
            html2text
            icalendar
            pip
            pycairo
            pygobject3
            pynvim
            python-csmdirsearch
            python-gitlab
            python-Levenshtein
            pytz
            vobject
            watchdog
          ]
        )
      )

      (
        sublime-music-tmp.override {
          chromecastSupport = true;
          serverSupport = true;
        }
      )

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
      csmdirsearch
      dfeet
      discord
      dunst
      element-desktop
      elinks
      fd
      feh
      ffmpeg-full
      file
      firefox
      flameshot
      fortune
      fzf
      gcc
      git
      gitAndTools.hub
      gitAndTools.lab
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
      neofetch
      neovim
      nextcloud-client
      nodejs
      nodePackages.bash-language-server
      ocaml
      ocamlPackages.utop
      offlinemsmtp
      opam
      openssl
      pass
      pavucontrol
      picom
      pinentry
      playerctl
      poetry
      ranger
      redshift
      restic
      ripgrep
      rofi
      screenfetch
      screenkey
      scrot
      slack
      spotify
      steam
      texlive.combined.scheme-full
      tracktime
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
      wmctrl
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
