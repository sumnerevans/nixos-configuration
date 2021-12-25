{
  # Set the hostname
  networking.hostName = "tatooine";
  hardware.ramSize = 8;

  networking.interfaces.eth0.useDHCP = true;

  # Enable a lot of swap since we have enough disk. This way, if Airsonic eats
  # memory, it won't crash the box.
  swapDevices = [
    { device = "/var/swapfile"; size = 4096; }
  ];

  fileSystems = {
    "/" = { device = "/dev/disk/by-uuid/b477c98a-376a-4dd8-a46c-03e3187188d8"; fsType = "ext4"; };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  networking.firewall.allowedTCPPorts = [
    # Allow the Syncthing GUI through
    8384
    2022
    # Allow nginx through
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 8384 2022 ];

  # Enable mosh and et
  programs.mosh.enable = true;
  services.eternal-terminal.enable = true;

  # Expose Synapse through the firewall
  services.nginx = {
    enable = true;
    virtualHosts = {
      # Reverse proxy for Matrix client-server and server-server communication
      "matrix.tatooine.sumnerevans.com" = {
        enableACME = true;
        forceSSL = true;

        # If they access root, redirect to Element. If they access the API, then
        # forward on to Synapse.
        locations."/".return = "301 https://app.element.io";
        locations."/_matrix" = {
          proxyPass = "http://0.0.0.0:8008"; # without a trailing /
          extraConfig = ''
            access_log /var/log/nginx/matrix.access.log;
          '';
        };
      };
    };
  };
}
