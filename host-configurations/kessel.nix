{ config, lib, ... }: {
  hardware.isServer = true;

  # Set the hostname
  networking.hostName = "kessel";
  networking.domain = "nevarro.space";

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";

  networking.interfaces.eth0.useDHCP = true;

  # Enable a lot of swap since we have enough disk. This way, if Airsonic eats
  # memory, it won't crash the box.
  swapDevices = [
    { device = "/var/swapfile"; size = 4096; }
  ];

  fileSystems = {
    "/" = { device = "/dev/disk/by-uuid/eb9f58f4-7c21-4ddc-a2e6-c9816f01e7c8"; fsType = "ext4"; };
    "/mnt/postgresql-data" = { device = "/dev/disk/by-uuid/0a948381-d1c1-430d-ad1b-0841114a00b9"; fsType = "ext4"; };
  };

  # Allow temporary redirects directly to the reverse proxy.
  networking.firewall.allowedTCPPortRanges = [
    { from = 8008; to = 8015; }
  ];

  ############
  # Websites #
  ############
  services.nginx.enable = true;
  services.nginx.websites = [
    { hostname = "nevarro.space"; }
  ];

  ############
  # Services #
  ############
  services.grafana.enable = true;
  services.healthcheck.checkId = "ac320939-f60f-4675-a284-76e318080eda";
  services.logrotate.enable = true;

  # # Heisenbridge
  # services.heisenbridge = {
  #   enable = true;
  # } // (import ../secrets/matrix/appservices/heisenbridge.nix);

  # # LinkedIn <-> Matrix Bridge
  # services.linkedin-matrix = {
  #   enable = true;
  # } // (import ../secrets/matrix/appservices/linkedin-matrix.nix);

  # # Mjolnir
  # services.mjolnir.enable = true;

  # # PosgreSQL
  # services.postgresql.enable = true;
  # services.postgresql.dataDir = "/mnt/postgresql-data/${config.services.postgresql.package.psqlSchema}";
  # services.postgresqlBackup.enable = true;

  # # Quotesfilebot
  # services.quotesfilebot.enable = true;
  # services.quotesfilebot.passwordFile = "/etc/nixos/secrets/matrix/bots/quotesfilebot";

  # # Restic backup
  # services.backup.healthcheckId = "efe08f4f-c0bb-4901-967d-b33774c18d80";
  # services.backup.healthcheckPruneId = "7215d3b4-24d4-4ecf-9785-6b4161b3af28";

  # # Standupbot
  # services.standupbot.enable = true;
  # services.standupbot.passwordFile = "/etc/nixos/secrets/matrix/bots/standupbot";

  # # Synapse
  # services.matrix-synapse-custom = {
  #   enable = true;
  #   registrationSharedSecretFile = ../secrets/matrix/registration-shared-secret/kessel;
  #   emailCfg = {
  #     smtp_host = "smtp.migadu.com";
  #     smtp_port = 587;
  #     require_transport_security = true;

  #     smtp_user = "matrix@nevarro.space";
  #     smtp_pass = removeSuffix "\n" (readFile ../secrets/matrix/nevarro-smtp-pass);

  #     notif_from = "Nevarro %(app)s Admin <matrix@nevarro.space>";
  #     app_name = "Matrix";
  #     enable_notifs = true;
  #     notif_for_new_users = false;
  #     invite_client_location = "https://app.element.io";
  #   };
  # };
  # services.cleanup-synapse.environmentFile = "/etc/nixos/secrets/matrix/cleanup-synapse/kessel";
}
