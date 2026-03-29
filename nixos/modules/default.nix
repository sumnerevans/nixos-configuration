{ lib, pkgs, ... }:
{
  options = {
    hostCategory = lib.mkOption {
      type = lib.types.enum [
        "laptop"
        "server"
      ];
      description = "The type of host this configuration is for.";
    };

    ramSize = lib.mkOption {
      type = lib.types.int;
      description = "How much RAM the hardware has.";
    };
  };

  imports = [
    ./laptop.nix
    ./programs
    ./server.nix
    ./services
    ./users
  ];

  config = {
    time.timeZone = "America/Denver";

    boot = {
      tmp.useTmpfs = true;
      kernel.sysctl = {
        "fs.inotify.max_user_instances" = 524288;
        "fs.inotify.max_user_watches" = 524288;
      };
    };

    nix.settings.download-buffer-size = 4294967296; # 4 GiB

    environment.defaultPackages = [ pkgs.jq ];

    security.acme = {
      defaults.email = "admin@sumnerevans.com";
      acceptTerms = true;
    };

    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        StreamLocalBindUnlink = "yes";
      };
    };

    networking.firewall.allowedTCPPorts = [ 22 ];

    # Add exFAT driver
    system.fsPackages = [ pkgs.exfat ];

    # Enable tailscale across the fleet
    environment.systemPackages = [ pkgs.tailscale ];
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      openFirewall = true;
    };
  };
}
