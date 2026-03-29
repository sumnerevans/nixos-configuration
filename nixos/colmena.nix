{ nixpkgs, webfortune, ... }:
let
  system = "x86_64-linux";
in
{
  meta = {
    description = "Sumner's Personal Infrastructure";

    nixpkgs = import nixpkgs {
      inherit system;

      config = {
        permittedInsecurePackages = [ "olm-3.2.16" ];
        allowUnfree = true;
      };

      overlays = [
        (self: super: { inherit (webfortune.packages.${system}) webfortune; })

        # Wait until https://github.com/NixOS/nixpkgs/pull/504778 is merged
        (final: prev: {
          isso = prev.isso.overrideAttrs (old: rec {
            src = prev.fetchFromGitHub {
              owner = "isso-comments";
              repo = "isso";
              rev = "0.14.0";
              hash = "sha256-8kXqqiMXxF0wCJ+AzYT8j0rjuhlXO3F6UJbump672b4=";
            };

            npmDeps = prev.fetchNpmDeps {
              inherit src;
              hash = "sha256-e3r5iZLmXlf5YBPGgeNBDkdgfbNcIZIXbRLyyoyJiTU=";
            };

            propagatedBuildInputs =
              old.propagatedBuildInputs
              ++ (with prev.python3Packages; [
                setuptools
                gevent
                mistune
              ]);
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

  # ThinkPad T14s AMD Gen 3
  scarif = {
    deployment = {
      allowLocalDeployment = true;
      targetHost = null;

      tags = [ "laptop" ];
    };

    imports = [ ./hosts/scarif ];
  };
}
