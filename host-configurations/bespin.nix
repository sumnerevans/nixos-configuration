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

    "matrix.sumnerevans.com" = {
      enableACME = true;
      forceSSL = true;

      # If they access root, redirect to Element. If they access the API, then
      # forward on to Synapse.
      locations."/".return = "301 https://app.element.io";
      locations."/_matrix" = {
        proxyPass = "http://5.161.43.204:8008"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/matrix.access.log;
        '';
      };
      locations."/_matrix/federation/" = {
        proxyPass = "http://5.161.43.204:8009"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/matrix-federation.access.log;
        '';
      };
      locations."~ ^/_matrix/client/.*/(sync|events|initialSync)" = {
        proxyPass = "http://5.161.43.204:8010"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/matrix-synchotron.access.log;
        '';
      };
      locations."~ ^/(_matrix/media|_synapse/admin/v1/(purge_media_cache|(room|user)/.*/media.*|media/.*|quarantine_media/.*|users/.*/media))" = {
        proxyPass = "http://5.161.43.204:8011"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/matrix-media-repo.access.log;
        '';
      };
    };
  };

  ############
  # Services #
  ############
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

  # PosgreSQL
  services.postgresql.enable = true;
  services.postgresqlBackup.enable = true;
}
