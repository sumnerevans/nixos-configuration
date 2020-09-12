{ config, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jedha";
  networking.networkmanager = {
    enable = true;
    enableStrongSwan = true;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "America/Denver";

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
    pinentry-curses
    pinentry-gnome
    (python38.withPackages(ps: with ps; [
      dateutil
      fuzzywuzzy
      goobook
      html2text
      icalendar
      pip
      pygobject3
      pynvim
      python-gitlab
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

  fonts.fonts = with pkgs; [
    font-awesome_4
    iosevka
    noto-fonts
    noto-fonts-emoji
    powerline-fonts
    open-sans
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Iosevka Term"
      ];
      sansSerif = [
        "Open Sans"
      ];
      serif = [
        "Noto Serif"
      ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:
  services.clipmenu.enable = true;
  services.lorri.enable = true;
  services.picom = {
    enable = true;
    shadow = true;
    shadowExclude = [
      "name = 'Notification'"
      "class_g = 'Conky'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Cairo-clock'"
      "class_g = 'i3-frame'"
      "_GTK_FRAME_EXTENTS@:c"
    ];
    fade = true;
    fadeDelta = 5;
    inactiveOpacity = 0.8;
    opacityRules = [
      "100:class_g = 'obs'"
    ];
    vSync = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "3l";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.tapping = false;

  # Enable i3
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.sumner = {
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/sumner";
    hashedPassword = "$6$p0WfA2vae4b5QahY$/qCwuUV.tVZEajIq7xcFUqcVD6iXAOK0kVPxki27flq4NXNn1XTTbH4s0RQedyKArAg1D2.Y0V0xQF.B/TME90";
    extraGroups = [
      "wheel"  # Enable 'sudo' for the user.
      "networkmanager"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  fileSystems."/home/sumner/tmp" =
    {
      fsType = "tmpfs";
      options = [ "nosuid" "nodev" "size=32G" ];
    };

  fileSystems."/home/sumner/.cache" =
    {
      fsType = "tmpfs";
      options = [ "nosuid" "nodev" "size=32G" ];
    };

}
