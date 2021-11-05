{ config, lib, ... }: {
  hardware.isServer = true;

  # Set the hostname
  networking.hostName = "bespin";
  networking.domain = "sumnerevans.com";

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

  fileSystems = {
    "/" = { device = "/dev/sda"; fsType = "ext4"; };
    "/mnt/syncthing-data" = { device = "/dev/disk/by-id/scsi-0Linode_Volume_syncthing-data"; fsType = "ext4"; };
  };

  # Websites
  services.nginx.websites = [
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

  # PR Tracker has moved to Nevarro
  services.nginx.virtualHosts."pr-tracker.${config.networking.domain}" = {
    addSSL = true;
    enableACME = true;
    locations."/".return = "301 https://pr-tracker.nevarro.space$request_uri";
  };

  # Host reverse proxy services
  services.nginx.virtualHosts."tunnel.${config.networking.domain}" = {
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
  services.healthcheck.checkId = "43c45999-cc22-430f-a767-31a1a17c6d1b";
  services.isso.enable = true;
  services.logrotate.enable = true;
  services.syncthing.enable = true;
  services.vaultwarden.enable = true;
  services.xandikos.enable = true;

  services.gonic = {
    enable = true;
    scanInterval = 1;
    virtualHost = "gonic.sumnerevans.com";
  };
  services.nginx.virtualHosts."gonic.sumnerevans.com" = {
    forceSSL = true;
    enableACME = true;
  };

  # Longview
  services.longview.enable = true;
  services.longview.apiKeyFile = ../secrets/longview/bespin;

  # PR Tracker
  services.pr-tracker = {
    enable = true;
    githubApiTokenFile = "/etc/nixos/secrets/pr-tracker-github-token";
    sourceUrl = "https://git.sr.ht/~sumner/pr-tracker";
  };

  # Restic backup
  services.backup.healthcheckId = "a42858af-a9d7-4385-b02d-2679f92873ed";
  services.backup.healthcheckPruneId = "14ed7839-784f-4dee-adf2-f9e03c2b611e";

  # Synapse
  services.matrix-synapse-custom.enable = true;
  services.matrix-synapse-custom.registrationSharedSecretFile = ../secrets/matrix/registration-shared-secret/bespin;
  services.cleanup-synapse.environmentFile = "/etc/nixos/secrets/matrix/cleanup-synapse/bespin";
  services.matrix-vacation-responder = {
    enable = true;
    username = "@sumner:sumnerevans.com";
  };

  # PosgreSQL
  services.postgresql.enable = true;
  services.postgresqlBackup.enable = true;
}
