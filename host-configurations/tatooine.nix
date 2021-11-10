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

  # Allow the Syncthing GUI through
  networking.firewall.allowedTCPPorts = [ 8384 2022 ];
  networking.firewall.allowedUDPPorts = [ 8384 2022 ];

  # Add the Beeper stack cert to the list of certs
  security.pki.certificateFiles = [
    ../secrets/beeper-localenv-root-ca.pem
  ];

  # Enable mosh and et
  programs.mosh.enable = true;
  services.eternal-terminal.enable = true;
}
