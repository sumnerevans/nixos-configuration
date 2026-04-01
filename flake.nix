{
  description = "Sumner's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    webfortune = {
      url = "github:sumnerevans/webfortune";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    menucalc = {
      url = "github:sumnerevans/menu-calc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mdf = {
      url = "github:sumnerevans/mdf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      colmena,
      nixpkgs,
      home-manager,
      webfortune,
      mdf,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          permittedInsecurePackages = [ "olm-3.2.16" ];
          allowUnfree = true;
        };

        overlays = [
          (self: super: { inherit (webfortune.packages.${system}) webfortune; })
          (self: super: { inherit (mdf.packages.${system}) mdf; })

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
    in
    {
      colmenaHive = colmena.lib.makeHive (import ./nixos/colmena.nix (inputs // { inherit pkgs; }));

      nixosConfigurations = {
        scarif = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            inherit pkgs;
          };
          modules = [
            ./nixos/modules
            ./nixos/hosts/scarif
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sumner = ./home-manager/host-configurations/scarif.nix;
            }
          ];
        };
      };

      formatter = pkgs.nixfmt-tree;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          cargo
          colmena.packages.${system}.colmena
          git-crypt
          gnutar
          openssl
          pass
          pre-commit
          python3
        ];
      };
    };
}
