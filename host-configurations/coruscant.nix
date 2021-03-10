{ config, lib, pkgs, modulesPath, ... }: {
  # Set the hostname
  networking.hostName = "coruscant";
  hardware.ramSize = 32;
}
