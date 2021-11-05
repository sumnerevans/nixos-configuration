{ config, lib, ... }: {
  hardware.isServer = true;
  boot.loader.grub = {
    forceInstall = true;
    device = "nodev";
  };

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
  services.nginx.enable = true;

  # Transitional redirects
  services.nginx.virtualHosts = {
    "bitwarden.sumnerevans.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://5.161.43.204:8222";
    };
    "dav.sumnerevans.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://5.161.43.204:8080";
    };
  };

  ############
  # Services #
  ############
  services.airsonic.enable = true;
  services.grafana.enable = true;
  services.healthcheck.checkId = "43c45999-cc22-430f-a767-31a1a17c6d1b";
  services.logrotate.enable = true;
  services.syncthing.enable = true;

  # Longview
  services.longview.enable = true;
  services.longview.apiKeyFile = ../secrets/longview/bespin;

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
