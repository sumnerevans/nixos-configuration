{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    # Services
    ./airsonic.nix
    ./glance.nix
    ./gonic.nix
    ./grafana.nix
    ./isso.nix
    ./syncthing.nix
    ./webfortune.nix
  ];

  hostCategory = "server";

  networking = {
    hostName = "morak";
    domain = "sumnerevans.com";

    firewall = {
      allowPing = true;

      # Allow temporary redirects directly to the reverse proxy.
      allowedTCPPorts = [
        8222
        8080
      ];
      allowedTCPPortRanges = [
        {
          from = 8008;
          to = 8015;
        }
      ];
    };
  };

  # Enable fail2ban
  services.fail2ban.enable = true;

  ############
  # Services #
  ############
  services.logrotate.enable = true;
  services.syncthing.enable = true;
  services.vaultwarden.enable = true;

  # Gomuks
  services.nginx.virtualHosts."gomuks.sumnerevans.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:29325";
      proxyWebsockets = true;
    };
  };
  systemd.services.gomuks = {
    description = "Gomuks Web";
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    environment.HOME = "/root";
    serviceConfig = {
      ExecStart = "${pkgs.gomuks-web}/bin/gomuks-web";
      Restart = "on-failure";
    };
  };

  # Gonic
  services.gonic2 = {
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
    disks = [
      "/"
      "/mnt/syncthing-data"
      "/mnt/syncthing-pictures-tmp"
    ];
  };

  # Restic backup
  services.backup.healthcheckId = "6c9caf62-4f7b-4ef7-82ac-d858d3bcbcb5";
  services.backup.healthcheckPruneId = "f90ed04a-2596-49d0-a89d-764780a27fc6";

  # Add a backup service for the actual data.
  services.backup.backups.syncthing-pictures-tmp-data = {
    path = "/mnt/syncthing-pictures-tmp";
  };
}
