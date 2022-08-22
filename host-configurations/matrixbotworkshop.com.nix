{ config, lib, ... }: {
  hardware.isServer = true;

  # Set the hostname
  networking.hostName = "matrixbotworkshop.com";
  networking.domain = "matrixbotworkshop.com";

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";

  networking.interfaces.eth0.useDHCP = true;

  # Enable a lot of swap since we have enough disk.
  swapDevices = [
    { device = "/var/swapfile"; size = 4096; }
  ];

  fileSystems = {
    "/" = { device = "/dev/disk/by-uuid/78831675-9f80-462b-b9fc-75a0efa368e5"; fsType = "ext4"; };
  };

  # Allow temporary redirects directly to the reverse proxy.
  networking.firewall.allowedTCPPorts = [ 8222 8080 ];
  networking.firewall.allowedTCPPortRanges = [
    { from = 8008; to = 8015; }
  ];

  ############
  # Services #
  ############
  # Synapse
  services.matrix-synapse.enable = true;
}
