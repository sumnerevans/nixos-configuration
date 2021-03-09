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
  environment.systemPackages = with pkgs; [
    # TODO put a lot of these in to the window manager serivce
    aspell
    aspellDicts.en
    baobab
    bind
    bitwarden
    bitwarden-cli
    chezmoi
    clang
    dfeet
    ffmpeg-full
    gcc
    gnumake
    guvcview
    hugin
    iftop
    isync
    kbdlight
    kdenlive
    khal
    libnotify
    libreoffice-fresh
    light
    lm_sensors
    lsof
    mutt
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
    screen
    screenfetch
    # syncthing-gtk
    usbutils
    vdirsyncer
    wireguard
    wireshark
    wmctrl
    yarn
  ];
}
