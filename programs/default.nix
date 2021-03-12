{ config, pkgs, lib, python38Packages, ... }:
{
  imports = [
    ./zsh.nix
  ];

  # Automatically start an SSH agent.
  programs.ssh.startAgent = true;

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Allow unfree software.
  nixpkgs.config.allowUnfree = true;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # https://github.com/nix-community/nix-direnv#via-configurationnix-in-nixos
  # Persist direnv derivations across garbage collections.
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  # Packages to install
  environment.systemPackages = with pkgs; [
    # TODO put a lot of these in to the window manager serivce
    lm_sensors
    neovim
    wireguard
    wmctrl
  ];
}
