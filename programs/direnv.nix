{ config, pkgs, ... }:
{
  # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
  environment.systemPackages = with pkgs; [ direnv nix-direnv ];

  # Persist direnv derivations across garbage collections.
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  environment.pathsToLink = [ "/share/nix-direnv" ];
}
