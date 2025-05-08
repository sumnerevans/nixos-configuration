{
  description = "Sumner's NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    webfortune = {
      url = "github:sumnerevans/webfortune";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, webfortune }:
    {
      nixosConfigurations = let
        mkCfg = hostSpecific:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [ ./configuration.nix hostSpecific ];
          };
      in {
        tatooine = mkCfg ./host-configurations/tatooine.nix;
        coruscant = mkCfg ./host-configurations/coruscant.nix;
        scarif = mkCfg ./host-configurations/scarif.nix;
        morak = mkCfg ./host-configurations/morak.nix;
        mustafar = mkCfg ./host-configurations/mustafar.nix;
      };
    } // (flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { system = system; };
      in {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              cargo
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
