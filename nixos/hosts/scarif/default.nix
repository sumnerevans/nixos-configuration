{
  imports = [
    ./hardware-configuration.nix
  ];

  hostCategory = "laptop";
  ramSize = 16;

  # The Framework kernel module currently fails to build with linuxPackages_latest.
  hardware.framework.enableKmod = false;

  networking.hostName = "scarif";

  # Allow temporary redirects directly to the reverse proxy.
  networking.firewall.allowedTCPPorts = [
    8222
    8080
  ];
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 8008;
      to = 8015;
    }
  ];

  programs.steam.enable = true;

  virtualisation.docker.enable = true;
  enableVirtualisation = true;

  zramSwap.enable = true;
}
