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
    { device = "/var/swapfile"; size = 4096; }
  ];

  fileSystems = {
    "/" = { device = "/dev/sda"; fsType = "ext4"; };
  };

  # Transitional redirects
  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    "matrix.nevarro.space" = {
      enableACME = true;
      forceSSL = true;

      # If they access root, redirect to Element. If they access the API, then
      # forward on to Synapse.
      locations."/".return = "301 https://app.element.io";
      locations."/_matrix" = {
        proxyPass = "http://5.161.43.147:8008"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/matrix.access.log;
        '';
      };
      locations."/_matrix/federation/" = {
        proxyPass = "http://5.161.43.147:8009"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/matrix-federation.access.log;
        '';
      };
      locations."~ ^/_matrix/client/.*/(sync|events|initialSync)" = {
        proxyPass = "http://5.161.43.147:8010"; # without a trailing /
        extraConfig = ''
          access_log /var/log/nginx/matrix-synchotron.access.log;
        '';
      };
      locations."~ ^/(_matrix/media|_synapse/admin/v1/(purge_media_cache|(room|user)/.*/media.*|media/.*|quarantine_media/.*|users/.*/media))" = {
        proxyPass = "http://5.161.43.147:8011"; # without a trailing /
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
  services.healthcheck.checkId = "0a1a1c13-e65d-4968-a498-c5709dcb2ae8";
  services.logrotate.enable = true;
  services.prometheus.enable = true;

  # Longview
  services.longview.enable = true;
  services.longview.apiKeyFile = ../secrets/longview/nevarro;
}
