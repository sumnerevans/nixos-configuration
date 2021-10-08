{ config, lib, ... }: {
  hardware.isServer = true;

  # Set the hostname
  networking.hostName = "praesitlyn";
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

  ############
  # Services #
  ############
  services.grafana.enable = true;
  services.healthcheck.checkId = "11c25e88-2ff7-44b7-805e-a7c7efe197eb";
  services.logrotate.enable = true;

  # Longview
  services.longview.enable = true;
  services.longview.apiKeyFile = ../secrets/longview/praesitlyn;

  # Restic backup
  services.backup.healthcheckId = "9d83ab91-b1e0-498a-a68c-05c8024c8377";
  services.backup.healthcheckPruneId = "3a67927c-d796-40c1-bd37-829e002a88af";

  # Synapse
  services.matrix-synapse-custom.enable = true;
  services.matrix-synapse-custom.registrationSharedSecretFile = ../secrets/matrix/registration-shared-secret/praesitlyn;
  services.heisenbridge = {
    enable = true;
  } // (import ../secrets/matrix/appservices/heisenbridge.nix);
  services.linkedin-matrix = {
    enable = true;
  } // (import ../secrets/matrix/appservices/linkedin-matrix.nix);
  services.cleanup-synapse.environmentFile = "/etc/nixos/secrets/matrix/cleanup-synapse/praesitlyn";

  # PosgreSQL
  services.postgresql.enable = true;
  services.postgresql.dataDir = "/mnt/postgresql-data/postgresql/11.1";
  services.postgresqlBackup.enable = true;
}
