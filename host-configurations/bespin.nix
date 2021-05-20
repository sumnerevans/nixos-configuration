{ config, ... }: {
  hardware.isServer = true;

  # Set the hostname
  networking.hostName = "bespin";
  networking.domain = "sumnerevans.com";

  # Bootloader timeout to 10 seconds.
  boot.loader.timeout = 10;

  # Allow reboots when automatically upgrading.
  system.autoUpgrade.allowReboot = true;

  # Automatically GC the nix store
  nix.gc.automatic = true;

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";

  networking.interfaces.eth0.useDHCP = true;

  # Enable a lot of swap since we have enough disk. This way, if Airsonic eats
  # memory, it won't crash the box.
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

  # Websites
  nginx.websites = [
    { hostname = "the-evans.family"; }
    { hostname = "qs.${config.networking.domain}"; }
    {
      # sumnerevans.com
      hostname = config.networking.domain;
      extraLocations = {
        "/teaching" = {
          root = "/var/www";
          priority = 0;
          extraConfig = ''
            access_log /var/log/nginx/${config.networking.domain}.access.log;
            autoindex on;
          '';
        };
      };
      excludeTerms = [
        "/.well-known/"
        "/dark-theme.min.js"
        "/favicon.ico"
        "/js/isso.min.js"
        "/profile.jpg"
        "/robots.txt"
        "/style.css"
        "/teaching/csci564-s21/_static/"
      ];
    }
  ];

  # Services
  services.airsonic.enable = true;
  services.bitwarden_rs.enable = true;
  services.healthcheck.checkId = "43c45999-cc22-430f-a767-31a1a17c6d1b";
  services.isso.enable = true;
  services.logrotate.enable = true;
  services.longview.enable = true;
  services.matrix-synapse.enable = true;
  services.murmur.enable = true;
  services.syncthing.enable = true;
  services.thelounge.enable = true;
  services.xandikos.enable = true;

  # PosgreSQL
  services.postgresql.enable = true;
  services.postgresql.dataDir = "/mnt/postgresql-data/postgresql/11.1";
  services.postgresqlBackup.enable = true;
}
