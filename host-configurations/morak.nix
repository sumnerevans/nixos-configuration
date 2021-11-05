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
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

  fileSystems = {
    "/" = { device = "/dev/sda1"; fsType = "ext4"; };
    # "/mnt/syncthing-data" = { device = "/dev/disk/by-id/scsi-0Linode_Volume_syncthing-data"; fsType = "ext4"; };
  };

  ############
  # Websites #
  ############
  services.nginx.websites = [
    {
      # sumnerevans.com
      hostname = "sumnerevans.com";
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

  ############
  # Services #
  ############
  services.healthcheck.checkId = "e1acf12a-ebc8-456a-aac8-96336e14d974";

  # Restic backup
  services.backup.healthcheckId = "6c9caf62-4f7b-4ef7-82ac-d858d3bcbcb5";
  services.backup.healthcheckPruneId = "f90ed04a-2596-49d0-a89d-764780a27fc6";
}
