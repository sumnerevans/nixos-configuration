{ config, ... }:
{
  imports = [ ./hardware-configuration.nix ];

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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.sway.enable = true;
  programs.steam.enable = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  programs.dsearch = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target"; # Only start in graphical sessions
    };
  };
  programs.dms-shell.enable = true;
  programs.niri.enable = true;
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = config.users.users.sumner.home;
  };
}
