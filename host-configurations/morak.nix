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
  # Services #
  ############
  services.healthcheck.checkId = "e1acf12a-ebc8-456a-aac8-96336e14d974";
}
