{ config, lib, pkgs, ... }: with lib; let
  nixCfg = config.nix;
in
{
  config = mkMerge [
    # Allow unfree software.
    {
      nixpkgs.config.allowUnfree = true;
      environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
    }

    # If automatic garbage collection is enabled, delete 30 days.
    (mkIf nixCfg.gc.automatic {
      nix.gc.options = "--delete-older-than 30d";
    })

    # Use nix flakes
    {
      # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
      # Persist direnv derivations across garbage collections.
      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';
      nix.package = pkgs.nixUnstable;
    }

    # Cachix
    {
      nix.binaryCaches = [
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
      ];

      nix.binaryCachePublicKeys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
    }

    # nix-direnv
    {
      # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
      # Persist direnv derivations across garbage collections.
      nix.extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
      environment.pathsToLink = [ "/share/nix-direnv" ];
    }
  ];
}
