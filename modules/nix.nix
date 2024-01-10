{ config, lib, pkgs, ... }:
with lib;
let nixCfg = config.nix;
in {
  config = mkMerge [
    # Allow unfree software.
    {
      nixpkgs.config.allowUnfree = true;
      environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

      nix.settings.trusted-substituters = [
        "https://sumnerevans.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
    }

    # If automatic garbage collection is enabled, delete 30 days.
    (mkIf nixCfg.gc.automatic {
      nix.gc = {
        randomizedDelaySec = "45min";
        options = "--delete-older-than 30d";
      };
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
  ];
}
