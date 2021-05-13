#
# Contains convenience modules for configuring the hardware.
#
{ config, pkgs, lib, ... }: with lib; let
  cfg = config;
in
{
  imports = [
    ./bluetooth.nix
    ./bootloader.nix
    ./firewall.nix
    ./laptop.nix
    ./networking.nix
    ./tmpfs.nix
    ./v4l2loopback.nix
  ];

  options = {
    hardware.isPC = mkEnableOption "PC mode";
    hardware.isServer = mkEnableOption "server mode";
  };

  config = mkMerge [
    {
      assertions = [{
        assertion = cfg.isPC -> !cfg.isServer;
        message = "isPC and isServer are mutually exclusive";
      }];
    }

    (mkIf cfg.isPC {
      boot.loader.systemd-boot.enable = true;
      hardware.bluetooth.enable = true;
      networking.networkmanager.enable = true;

      # TODO fix this
      networking.firewall.enable = false;

      # Enable sound.
      hardware.pulseaudio.enable = true;
      hardware.pulseaudio.support32Bit = true;

      # Pipewire
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        # pulse.enable = true;
      };
    })

    (mkIf cfg.isServer { })
  ];
}
