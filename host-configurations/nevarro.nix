{ config, lib, ... }: with lib; {
  hardware.isServer = true;
  boot.loader.grub = {
    forceInstall = true;
    device = "nodev";
  };

  # Set the hostname
  networking.hostName = "nevarro";
  networking.domain = "nevarro.space";

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
    "/mnt/nevarro-postgresql-data" = { device = "/dev/disk/by-id/scsi-0Linode_Volume_nevarro-postgresql-data"; fsType = "ext4"; };
  };

  # Websites
  services.nginx.enable = true;
  services.nginx.websites = [
    { hostname = "nevarro.space"; }
  ];

  ############
  # Services #
  ############
  services.grafana.enable = true;
  services.healthcheck.checkId = "0a1a1c13-e65d-4968-a498-c5709dcb2ae8";
  services.logrotate.enable = true;

  # Heisenbridge
  services.heisenbridge = {
    enable = true;
  } // (import ../secrets/matrix/appservices/heisenbridge.nix);

  # LinkedIn <-> Matrix Bridge
  services.linkedin-matrix = {
    enable = true;
  } // (import ../secrets/matrix/appservices/linkedin-matrix.nix);

  # Longview
  services.longview.enable = true;
  services.longview.apiKeyFile = ../secrets/longview/nevarro;

  # Mjolnir
  services.mjolnir.enable = true;

  # PosgreSQL
  services.postgresql.enable = true;
  services.postgresql.dataDir = "/mnt/nevarro-postgresql-data/postgresql/11.1";
  services.postgresqlBackup.enable = true;

  # Quotesfilebot
  services.quotesfilebot.enable = true;
  services.quotesfilebot.passwordFile = "/etc/nixos/secrets/matrix/bots/quotesfilebot";

  # Restic backup
  services.backup.healthcheckId = "5af26654-5ca7-405a-b8c4-e00a2fc6a5b0";
  services.backup.healthcheckPruneId = "d58fb3c6-532b-4db2-9538-c3a5908f3d2c";

  # Standupbot
  services.standupbot.enable = true;
  services.standupbot.passwordFile = "/etc/nixos/secrets/matrix/bots/standupbot";

  # Synapse
  services.matrix-synapse-custom = {
    enable = true;
    registrationSharedSecretFile = ../secrets/matrix/registration-shared-secret/nevarro;
    emailCfg = {
      smtp_host = "smtp.migadu.com";
      smtp_port = 587;
      require_transport_security = true;

      smtp_user = "matrix@nevarro.space";
      smtp_pass = removeSuffix "\n" (readFile ../secrets/matrix/nevarro-smtp-pass);

      notif_from = "Nevarro %(app)s Admin <matrix@nevarro.space>";
      app_name = "Matrix";
      enable_notifs = true;
      notif_for_new_users = false;
      invite_client_location = "https://app.element.io";
    };
  };
  services.cleanup-synapse.environmentFile = "/etc/nixos/secrets/matrix/cleanup-synapse/nevarro";
}
