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
      restic-password = keyFor "restic-password" "root";
      restic-environment-variables = keyFor "restic-environment-variables" "root";
    };
  };
}
