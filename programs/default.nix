{ config, pkgs, lib, python38Packages, ... }:
{
  imports = [
    ./browsers.nix
    ./obs.nix
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

  # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
  # Persist direnv derivations across garbage collections.
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  # Packages to install
  environment.systemPackages = with pkgs; let
    csmdirsearch = callPackage ../pkgs/csmdirsearch.nix {};
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

      # TODO put a lot of these in to the window manager serivce
      aspell
      aspellDicts.en
      baobab
      bind
      bitwarden
      bitwarden-cli
      chezmoi
      clang
      csmdirsearch
      dfeet
      discord
      element-desktop
      fd
      ffmpeg-full
      file
      fortune
      fslint
      gcc
      gnumake
      guvcview
      hugin
      iftop
      imagemagick
      inkscape
      isync
      kbdlight
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
      mumble
      mutt
      neofetch
      neovim
      nodejs
      nodePackages.bash-language-server
      nox
      openssl
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
      screen
      screenfetch
      spotify
      steam
      # syncthing-gtk
      tokei
      tracktime
      tree
      trickle
      unzip
      usbutils
      vdirsyncer
      watchexec
      wget
      wireguard
      wireshark
      wmctrl
      write_stylus
      xournal
      yarn
      zip
    ];
}
