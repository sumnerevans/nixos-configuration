{ config, lib, ... }: {
  hardware.isServer = true;

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

  # Websites
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

  # Mumble
  services.murmur.enable = true;

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
  services.matrix-synapse-custom.enable = true;
  services.matrix-synapse-custom.registrationSharedSecretFile = ../secrets/matrix/registration-shared-secret/nevarro;
  services.cleanup-synapse.environmentFile = "/etc/nixos/secrets/matrix/cleanup-synapse/bespin";
}
