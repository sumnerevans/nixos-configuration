{ config, lib, ... }: {
  hardware.isServer = true;

  # Set the hostname
  networking.hostName = "morak";
  networking.domain = "sumnerevans.com";

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";

  networking.interfaces.eth0.useDHCP = true;

  # Enable a lot of swap since we have enough disk. This way, if Airsonic eats
  # memory, it won't crash the box.
  swapDevices = [
    { device = "/var/swapfile"; size = 4096; }
  ];

  fileSystems = {
    "/" = { device = "/dev/disk/by-uuid/78831675-9f80-462b-b9fc-75a0efa368e5"; fsType = "ext4"; };
    "/mnt/syncthing-data" = { device = "/dev/disk/by-uuid/930c8bdb-7b71-4bdf-b478-6e85218cad37"; fsType = "ext4"; };
    "/mnt/postgresql-data" = { device = "/dev/disk/by-uuid/3d8eb9ca-e8ea-4231-b2a6-4fc5367ccb8a"; fsType = "ext4"; };
    "/mnt/syncthing-pictures-tmp" = { device = "/dev/disk/by-uuid/bfc8d39f-31e0-4261-9447-91bc7e39bb2f"; fsType = "ext4"; };
  };

  # Allow temporary redirects directly to the reverse proxy.
  networking.firewall.allowedTCPPorts = [ 8222 8080 ];
  networking.firewall.allowedTCPPortRanges = [
    { from = 8008; to = 8015; }
  ];

  ############
  # Websites #
  ############
  services.nginx.enable = true;
  services.nginx.websites = [
    { hostname = "the-evans.family"; }
    { hostname = "qs.sumnerevans.com"; }
    {
      # sumnerevans.com
      hostname = "sumnerevans.com";
      extraLocations = {
        "/teaching" = {
          root = "/var/www";
          priority = 0;
          extraConfig = ''
            access_log /var/log/nginx/sumnerevans.com.access.log;
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

  # Host reverse proxy services
  services.nginx.virtualHosts."tunnel.sumnerevans.com" = {
    addSSL = true;
    enableACME = true;

    extraConfig = ''
      error_page 502 /50x.html;
    '';

    locations = {
      "/50x.html".root = "/usr/share/nginx/html";
      "/".proxyPass = "http://localhost:1337/";
    };
  };

  ############
  # Services #
  ############
  services.airsonic.enable = true;
  services.grafana.enable = true;
  services.isso.enable = true;
  services.logrotate.enable = true;
  services.syncthing.enable = true;
  services.vaultwarden.enable = true;
  services.xandikos.enable = true;

  # Gonic
  services.gonic = {
    enable = true;
    scanInterval = 1;
    virtualHost = "music.sumnerevans.com";
    musicDir = "/mnt/syncthing-data/Music";
  };
  services.nginx.virtualHosts."music.sumnerevans.com" = {
    forceSSL = true;
    enableACME = true;
  };

  services.healthcheck = {
    checkId = "e1acf12a-ebc8-456a-aac8-96336e14d974";
    disks = [ "/" "/mnt/syncthing-data" "/mnt/postgresql-data" ];
  };

  # Mumble
  services.murmur.enable = true;

  # PosgreSQL
  services.postgresql.enable = true;
  services.postgresql.dataDir = "/mnt/postgresql-data/${config.services.postgresql.package.psqlSchema}";
  services.postgresqlBackup.enable = true;

  # Restic backup
  services.backup.healthcheckId = "6c9caf62-4f7b-4ef7-82ac-d858d3bcbcb5";
  services.backup.healthcheckPruneId = "f90ed04a-2596-49d0-a89d-764780a27fc6";

  # Synapse
  services.matrix-synapse-custom.enable = true;
  services.matrix-synapse-custom.registrationSharedSecretFile = ../secrets/matrix/registration-shared-secret/morak;
  services.cleanup-synapse.environmentFile = "/etc/nixos/secrets/matrix/cleanup-synapse/morak";
  services.matrix-vacation-responder = {
    enable = true;
    username = "@sumner:sumnerevans.com";
    homeserver = "https://matrix.sumnerevans.com";
  };
}
