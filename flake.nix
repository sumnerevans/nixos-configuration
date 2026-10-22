{
  description = "Sumner's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

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
      inputs.flake-parts.follows = "flake-parts";
    };

    menucalc = {
      url = "github:sumnerevans/menu-calc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mdf = {
      url = "github:sumnerevans/mdf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dcal = {
      url = "github:AvengeMedia/dankcalendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tracktime = {
      url = "github:sumnerevans/tracktime";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    offlinemsmtp = {
      url = "github:sumnerevans/offlinemsmtp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    mailnotify = {
      url = "github:sumnerevans/mailnotify";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      colmena,
      nixpkgs,
      home-manager,
      nur,

      mdf,
      tracktime,
      offlinemsmtp,
      webfortune,
      mailnotify,
      nixos-hardware,
      ...
    }:
    let
      system = "x86_64-linux";
      nixpkgsConfig = {
        permittedInsecurePackages = [ "olm-3.2.16" ];
        allowUnfree = true;
      };

      overlays = [
        (self: super: { inherit (mailnotify.packages.${system}) mailnotify; })
        (self: super: { inherit (mdf.packages.${system}) mdf; })
        (self: super: { inherit (offlinemsmtp.packages.${system}) offlinemsmtp; })
        (self: super: { inherit (tracktime.packages.${system}) tracktime; })
        (self: super: { inherit (webfortune.packages.${system}) webfortune; })
        nur.overlays.default

        # https://github.com/NixOS/nixpkgs/pull/576662
        (final: prev: {
          khal = prev.khal.overrideAttrs (_: {
            sphinxBuilders = [ "html man" ];
          });
        })

        # The upstream keyring tests fail in Nix builds; see https://github.com/NixOS/nixpkgs/issues/576985
        (final: prev: {
          udiskie = prev.udiskie.overrideAttrs (_: {
            doCheck = false;
          });
        })
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
        config = nixpkgsConfig;
      };
    in
    {
      colmenaHive = colmena.lib.makeHive (import ./nixos/colmena.nix (inputs // { inherit pkgs; }));

      nixosConfigurations = {
        scarif = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            {
              nixpkgs.config = nixpkgsConfig;
              nixpkgs.overlays = overlays;
            }
            ./nixos/modules
            ./nixos/hosts/scarif
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "bak";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sumner = ./home-manager/host-configurations/scarif.nix;
            }
            nixos-hardware.nixosModules.framework-intel-core-ultra-series3
          ];
        };
        mustafar = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs;
          modules = [
            {
              nixpkgs.config = nixpkgsConfig;
              nixpkgs.overlays = overlays;
            }
            ./nixos/modules
            ./nixos/hosts/mustafar
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.backupFileExtension = "bak";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.sumner = ./home-manager/host-configurations/mustafar.nix;
            }
          ];
        };
      };

      formatter.${system} = pkgs.nixfmt-tree;

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
