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

  ############
  # Services #
  ############
  services.airsonic.enable = true;
  services.healthcheck.checkId = "43c45999-cc22-430f-a767-31a1a17c6d1b";
  services.isso.enable = true;
  services.logrotate.enable = true;
  services.syncthing.enable = true;
  services.vaultwarden.enable = true;
  services.xandikos.enable = true;

  # Longview
  services.longview.enable = true;
  services.longview.apiKeyFile = ../secrets/bespin-longview-api-key;

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
  services.matrix-synapse.enable = true;
  services.matrix-synapse.registration_shared_secret = lib.removeSuffix "\n"
    (builtins.readFile ../secrets/matrix-registration-shared-secret);

  services.cleanup-synapse.environmentFile = "/etc/nixos/secrets/bespin-cleanup-synapse-environment";

  services.heisenbridge = {
    enable = true;
    appServiceToken = "wyujLh8kjpmk2bfKeEE3sZ2gWOEUBKK5";
    homeserverToken = "yEHs7lthD2ZHUibJOAv1APaFhEjxN5PT";
  };

  services.mx-puppet-slack = {
    enable = true;
    appServiceToken = "7d41cf7f-48f2-4049-b10c-aa3212970252";
    homeserverToken = "ccc42ba6-b9be-4531-b493-00bde4a7de18";
    settings = {
      bridge = {
        domain = "localhost";
        homeserverUrl = "http://localhost:8008";
      };
      oauth = {
        enabled = true;
        clientId = "14071139778.2289586013335";
        clientSecret = "b7b33ebb49aa9af7cbb88de4a86d95f3";
        redirectPath = "/oauth";
        redirectUri = "https://slack.sumnerevans.com/oauth";
      };
      backfill = {
        initialLimit = 100;
        missedLimit = 100;
      };
    };
  };
  services.nginx.virtualHosts."slack.${config.networking.domain}" = {
    addSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://[::1]:8432";
      extraConfig = ''
        access_log /var/log/nginx/matrix.access.log;
      '';
    };
  };

  # PosgreSQL
  services.postgresql.enable = true;
  services.postgresql.dataDir = "/mnt/postgresql-data/postgresql/11.1";
  services.postgresqlBackup.enable = true;
}
