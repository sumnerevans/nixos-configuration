{ config, lib, ... }:
with lib;
let nixCfg = config.nix;
in {
  config = mkMerge [
    # Allow unfree software.
    {
      nixpkgs.config.allowUnfree = true;
      environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
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
    }

    # Allow large downloads
    {
      nix.settings.download-buffer-size = 4294967296; # 4 GiB
    }
  ];
}
