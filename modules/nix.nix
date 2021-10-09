{ config, lib, pkgs, ... }: with lib; let
  nixCfg = config.nix;
in
{
  options = {
    nix.enableRemoteBuildOnCoruscant = mkEnableOption "Enable remote builds on coruscant";
  };

  config = mkMerge [
    # Allow unfree software.
    {
      nixpkgs.config.allowUnfree = true;
      environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
    }

    # If automatic garbage collection is enabled, delete 30 days.
    (
      mkIf nixCfg.gc.automatic {
        nix.gc.options = "--delete-older-than 30d";
      }
    )

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

    # Allow builds to happen on coruscant
    (
      mkIf nixCfg.enableRemoteBuildOnCoruscant {
        nix = {
          buildMachines = [
            {
              hostName = "coruscant";
              system = "x86_64-linux";
              maxJobs = 1;
              speedFactor = 2;
              supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
              mandatoryFeatures = [];
            }
            {
              hostName = "coruscant-lan";
              system = "x86_64-linux";
              maxJobs = 1;
              speedFactor = 2;
              supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
              mandatoryFeatures = [];
            }
          ];
          distributedBuilds = true;
          extraOptions = ''
            builders-use-substitutes = true
          '';
        };

        programs.ssh = let
          coruscantPublicIp = lib.removeSuffix "\n" (builtins.readFile ../secrets/coruscant-ip);
        in
          {
            extraConfig = ''
              Host coruscant
                  IdentityFile /etc/nixos/secrets/nix-remote-build
                  HostName ${coruscantPublicIp}
                  Port 32

              Host coruscant-lan
                  IdentityFile /etc/nixos/secrets/nix-remote-build
                  HostName 192.168.0.14
                  Port 32
            '';
            knownHosts = {
              coruscant = {
                hostNames = [ "192.168.0.14" coruscantPublicIp ];
                publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcO1lMaMPbL2cr4XdKc6bQJIbQylIXaYfX0S+NN3z0AMw3HCfsNCwlWoxyjIbZBlP3aSrdTITq3eB0gw3l25029h3Q4Dve+I2hf6jpltaGVlpsyhMN8xu9yoqadd0cG71kn6Wn5/BlpaWZtrJy7Px9luCyeuDx+vkC05CLb28sjwYVdTzbuePygUONL7cH6Xd2ulLDW+dFoZIHwraEsqHk9AQRV3f2hokxG/VpbxbVAY7XNOkIrsfmX6y4IccUddffgs8uqsObHEWniPdWOcEocRJ4exORBoyS5SXvcHzUtGi8Q0jGPfKkSFPEYUNcgw0QlU4dzrT/xqm0COcOoXKK58+tZH/YMu0bshp+vIK3HDCCfcRtuv1ZMF/AFbHdY3fglUu3YK2Jpm5Vr8KzljqQXW3ekboILxZpuP2LA3YErS1lpaj3sbOlsfxNQhG7V8/gqo1PBQ4w//7wlav0TOY5GZD1Tw2lduaSAFuFHxVGBOy4Xu31mxa2Qej5YKc71VU= sumner@coruscant-nixos";
              };
            };
          };
      }
    )
  ];
}
