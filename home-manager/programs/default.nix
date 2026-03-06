{
  config,
  lib,
  pkgs,
  ...
}:
with pkgs;
let
  hasGui = config.wayland.enable || config.xorg.enable;
in
{
  home.packages = [
    # Shell Utilities
    aspell
    aspellDicts.en
    bind
    czkawka
    fastfetch
    fd
    file
    fortune
    iftop
    libarchive
    libheif
    libnotify
    libxml2
    lsof
    mkpasswd
    ncdu
    nodejs
    nox
    openssl
    pciutils
    pcre
    pwgen
    ranger
    restic
    ripgrep
    screen
    screenfetch
    tokei
    tree
    unzip
    usbutils
    wget
    xdg-utils
    zip

    # Python
    (python3.withPackages (
      ps: with ps; [
        python-dateutil
        fuzzywuzzy
        html2text
        icalendar
        pillow
        pip
        pycairo
        pygobject3
        pynvim
        levenshtein
        pytz
        tabulate
        vobject
        watchdog
      ]
    ))
  ]
  ++ lib.optionals hasGui [
    # Configuration GUIs
    gnome-power-manager
    networkmanagerapplet

    # GUI Tools
    baobab
    # bitwarden-desktop
    styluslabs-write-bin
    xournalpp

    # Virtual Machine Client
    virt-manager

    (thunar.override {
      thunarPlugins = [
        thunar-archive-plugin
        thunar-volman
      ];
    })
  ];

  programs.bat.enable = true;
  programs.bottom.enable = true;
  programs.home-manager.enable = true;
  programs.htop.enable = true;
  programs.noti.enable = true;
  programs.password-store.enable = true;

  # TODO ssh
}
