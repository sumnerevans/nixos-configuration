{ pkgs, ... }:
let
  keyFor = keyname: for: {
    keyFile = "/etc/nixos/secrets/${keyname}";
    user = for;
    group = for;
  };
in
{
  meta = {
    description = "Sumner's Personal Infrastructure";

    nixpkgs = pkgs;
  };

  defaults =
    { config, ... }:
    {
      imports = [ ./modules ];

      deployment.replaceUnknownProfiles = true;

      swapDevices = [
        {
          device = "/var/swapfile";
          size = 4096;
        }
      ];

      services.logrotate.enable = true;
    };

  morak = {
    deployment = {
      targetHost = "morak.sumnerevans.com";
      tags = [
        "hetzner"
        "ashburn"
      ];
    };

    imports = [ ./hosts/morak ];

    deployment.keys = {
      isso_comments_env = keyFor "isso_comments_env" "root";
    };
  };
}
