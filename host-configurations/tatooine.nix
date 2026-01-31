{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Set the hostname
  networking.hostName = "tatooine";
  networking.domain = "sumnerevans.com";
  hardware.ramSize = 8;

  networking.interfaces.eth0.useDHCP = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Allow the Syncthing GUI through
  networking.firewall.allowedTCPPorts = [
    8384
    2022
  ];
  networking.firewall.allowedUDPPorts = [
    8384
    2022
  ];

  # Enable mosh and et
  programs.mosh.enable = true;
  services.eternal-terminal.enable = true;

  # Enable prometheus and grafana for debugging hungryserv
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      # Hungryserv
      {
        job_name = "hungryserv-dev";
        scrape_interval = "15s";
        static_configs = [
          {
            targets = [ "0.0.0.0:8001" ];
            labels = {
              instance = "hungryserv-dev";
            };
          }
        ];
      }
    ];
  };
  services.grafana.enable = true;

  services.nginx = {
    enable = true;
    proxyTimeout = "1h";
    virtualHosts."matrix.tatooine.sumnerevans.com" = {
      addSSL = true;
      enableACME = true;

      extraConfig = ''
        error_page 502 /50x.html;
      '';

      locations = {
        "/50x.html".root = "/usr/share/nginx/html";

        # Hungryserv
        "/" = {
          recommendedProxySettings = true;
          proxyPass = "http://localhost:8009";
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b477c98a-376a-4dd8-a46c-03e3187188d8";
      fsType = "ext4";
    };
  };

  # Enable a lot of swap since we have enough disk.
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

}
