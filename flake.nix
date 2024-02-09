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
      nixosConfigurations = {
        tatooine = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ./host-configurations/tatooine.nix ];
        };
        coruscant = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ./host-configurations/coruscant.nix ];
        };
        scarif = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ./host-configurations/scarif.nix ];
        };
        morak = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ./host-configurations/morak.nix ];
        };
        mustafar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./configuration.nix ./host-configurations/mustafar.nix ];
        };
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
              nodePackages.bash-language-server
              openssl
              pass
              pre-commit
              python3
              rnix-lsp
            ];
          };
        };
      }));
}
