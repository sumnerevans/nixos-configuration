{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  hostCategory = "laptop";
  ramSize = 32;

  deployment.keys =
    let
      keyFor = keyname: for: {
        keyCommand = [
          "cat"
          "secrets/${keyname}"
        ];
        user = for;
        group = for;
      };
    in
    {
    };

  networking.hostName = "scarif";

  services.thinkfan.enable = true;

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
}
