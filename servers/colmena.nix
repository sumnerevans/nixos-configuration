{ nixpkgs, webfortune, ... }:
let
  system = "x86_64-linux";
in
{
  meta = {
    description = "Sumner's Personal Infrastructure";

    nixpkgs = import nixpkgs {
      inherit system;
      config.permittedInsecurePackages = [ "olm-3.2.16" ];

      overlays = [
        (self: super: { inherit (webfortune.packages.${system}) webfortune; })
        (final: prev: {
          isso = prev.isso.overrideAttrs (old: rec {
            src = prev.fetchFromGitHub {
              owner = "isso-comments";
              repo = "isso";
              rev = "09cddc1940c837cbd46559db49459d20f670cd16";
              hash = "sha256-dMKfgudJBprXsers/nENnWVmyNPyJIPyNXO/fdZ6bKM=";
            };

            npmDeps = prev.fetchNpmDeps {
              inherit src;
              hash = "sha256-e3r5iZLmXlf5YBPGgeNBDkdgfbNcIZIXbRLyyoyJiTU=";
            };
          });
        })
      ];
    };
  };

  defaults =
    { config, ... }:
    {
      imports = [ ./modules ];

      deployment.replaceUnknownProfiles = true;

      system.stateVersion = "23.05";

      swapDevices = [
        {
          device = "/var/swapfile";
          size = 4096;
        }
      ];

      services.logrotate.enable = true;
    };

  jedha = {
    deployment = {
      targetHost = "192.168.0.168";
      tags = [ "belleview" ];
    };

    imports = [ ./hosts/jedha ];
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
  };
}
