{
  description = "Sumner's NixOS configuration";
  inputs = {
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    webfortune = {
      url = "github:sumnerevans/webfortune";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, colmena, nixpkgs, flake-utils, ... }:
    {
      nixosConfigurations = let
        mkCfg = hostSpecific:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [ ./configuration.nix hostSpecific ];
          };
      in {
        coruscant = mkCfg ./host-configurations/coruscant.nix; # Desktop PC
        morak = mkCfg ./host-configurations/morak.nix; # Hetzner Server
        mustafar = mkCfg ./host-configurations/mustafar.nix; # Kohaku
        scarif = mkCfg ./host-configurations/scarif.nix; # ThinkPad T14s
        tatooine = mkCfg ./host-configurations/tatooine.nix; # ThinkPad T580
      };

      colmenaHive = colmena.lib.makeHive self.outputs.colmena;
      colmena = import ./servers/colmena.nix inputs;
    } // (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { system = system; };
      in {
        devShells = {
          default = pkgs.mkShell {
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
      }));
}
