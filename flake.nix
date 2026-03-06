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

    flake-parts.url = "github:hercules-ci/flake-parts";

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
  };

  outputs =
    inputs@{
      self,
      colmena,
      nixpkgs,
      flake-parts,
      ...
    }:
    (flake-parts.lib.mkFlake { inherit inputs; } {
      flake = {
        nixosConfigurations =
          let
            mkCfg =
              hostSpecific:
              nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                  ./configuration.nix
                  hostSpecific
                ];
              };
          in
          {
            coruscant = mkCfg ./host-configurations/coruscant.nix; # Desktop PC
            mustafar = mkCfg ./host-configurations/mustafar.nix; # Kohaku
            scarif = mkCfg ./host-configurations/scarif.nix; # ThinkPad T14s
            tatooine = mkCfg ./host-configurations/tatooine.nix; # ThinkPad T580
          };

        colmenaHive = colmena.lib.makeHive self.outputs.colmena;
        colmena = import ./nixos/colmena.nix inputs;
      };

      systems = [ "x86_64-linux" ];
      perSystem =
        {
          lib,
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs { inherit system; };

          formatter = pkgs.nixfmt-tree;

          devShells.default = pkgs.mkShell {
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
    });
}
