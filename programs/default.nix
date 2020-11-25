{ config, pkgs, lib, python38Packages, ... }:
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
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # Nix Package Overlays
  nixpkgs.overlays = [
    (
      self: super: {
        # Waiting for: https://github.com/NixOS/nixpkgs/issues/103723
        zathura = super.zathura.override {
          useMupdf = false;
        };
      }
    )
  ];

  # Packages to install
  environment.systemPackages = with pkgs; let
    csmdirsearch = callPackage ../pkgs/csmdirsearch.nix {};
    offlinemsmtp = callPackage ../pkgs/offlinemsmtp.nix {};
    python-csmdirsearch = callPackage ../pkgs/python-csmdirsearch.nix {};
    python-gitlab = callPackage ../pkgs/python-gitlab.nix {};
    sublime-music-tmp = callPackage ../pkgs/sublime-music.nix {};
    tracktime = callPackage ../pkgs/tracktime.nix {};
    menucalc = callPackage ../pkgs/menucalc.nix {};
  in
    [
      (
        python38.withPackages (
          ps: with ps; [
            dateutil
            fuzzywuzzy
            html2text
            i3ipc
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

      (
        xfce.thunar.override {
          thunarPlugins = [
            # xfce.thunar-archive-plugin
            # xfce.thunar-volman
          ];
        }
      )

      (
        chromium.override {
          commandLineArgs = "-high-dpi-support=0 -force-device-scale-factor=1";
        }
      )

      (
        google-chrome.override {
          commandLineArgs = "-high-dpi-support=0 -force-device-scale-factor=1";
        }
      )

      # TODO put a lot of these in to the window manager serivce
      alacritty
      arc-icon-theme
      arc-theme
      aspell
      aspellDicts.en
      baobab
      bash
      bat
      bind
      bitwarden
      bitwarden-cli
      chezmoi
      clang
      csmdirsearch
      dfeet
      discord
      element-desktop
      elinks
      fd
      feh
      ffmpeg-full
      file
      firefox
      fortune
      fslint
      fzf
      gcc
      git
      gitAndTools.hub
      gitAndTools.lab
      gnome-breeze
      gnumake
      guvcview
      htop
      hugin
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
      lm_sensors
      lsof
      menucalc
      mkpasswd
      mpv
      mumble
      mutt
      neofetch
      neovim
      nextcloud-client
      nodejs
      nodePackages.bash-language-server
      nox
      offlinemsmtp
      opam
      openssl
      pass
      pavucontrol
      pciutils
      picom
      pinentry
      playerctl
      poetry
      ranger
      restic
      ripgrep
      rmlint
      rofi
      rofi-pass
      screen
      screenfetch
      scrot
      spotify
      steam
      # syncthing-gtk
      texlive.combined.scheme-full
      tracktime
      tree
      trickle
      unzip
      usbutils
      vale
      vdirsyncer
      vim
      vscode
      w3m
      watchexec
      wget
      wireguard
      wireshark
      wmctrl
      write_stylus
      xournal
      yarn
      zathura
      zip
      zoom-us
    ];
}
