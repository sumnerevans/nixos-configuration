{
  description = "Sumner's NixOS configuration";
  inputs = {
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    webfortune = {
      url = "github:sumnerevans/webfortune";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
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
            morak = mkCfg ./host-configurations/morak.nix; # Hetzner Server
            mustafar = mkCfg ./host-configurations/mustafar.nix; # Kohaku
            scarif = mkCfg ./host-configurations/scarif.nix; # ThinkPad T14s
            tatooine = mkCfg ./host-configurations/tatooine.nix; # ThinkPad T580
          };

        colmenaHive = colmena.lib.makeHive self.outputs.colmena;
        colmena = import ./servers/colmena.nix inputs;
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
