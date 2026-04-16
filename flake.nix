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

          (final: prev: {
            niri = prev.niri.overrideAttrs (old: rec {
              pname = "niri";
              src = prev.fetchFromGitHub {
                owner = "ArthurHeymans";
                repo = "niri";
                rev = "97f3070f9889939990f7d5ab9ae2f5f7899c058c";
                hash = "sha256-5p0o1EJtlMNjR0frO0XqZAolgZN5hUVDb3/orduBkf4=";
              };

              cargoDeps = final.rustPlatform.fetchCargoVendor{
                  inherit src;
                  hash = "sha256-uKbCm7aW8uZNoJmiLrea8wH/ziwcu3l9AfXLY3g9x5Q=";
              };
            });
          })

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
