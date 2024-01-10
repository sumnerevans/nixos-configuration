# Contains convenience modules for configuring the hardware.
#
{ config, pkgs, lib, ... }:
with lib;
let cfg = config.hardware;
in {
  imports = [
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
        assertion = cfg.isPC -> !cfg.isServer && cfg.isServer -> !cfg.isPC;
        message = "isPC and isServer are mutually exclusive";
      }];

      boot.kernel.sysctl."fs.inotify.max_user_instances" = 524288;
      boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

      # Add exFAT driver
      system.fsPackages = [ pkgs.exfat ];
    }

    (mkIf cfg.isPC {
      boot.loader.systemd-boot.enable = true;
      networking.networkmanager.enable = true;

      hardware.bluetooth.enable = true;
      services.blueman.enable = true;

      # Pipewire
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
      };

      # Suspend on power button press instead of shutdown.
      services.logind.extraConfig = ''
        HandlePowerKey=suspend
      '';

      # Enable Flatpak.
      services.flatpak.enable = true;
      xdg.portal.enable = true;

      # Enable YubiKey smart card mode.
      services.pcscd.enable = true;

      # Enable firmware updating
      services.fwupd.enable = true;

      # Enable libvirtd and virt-manager on GUI-enabled computers
      virtualisation.libvirtd.enable = true;
      environment.systemPackages = [ pkgs.virt-manager ];
      users.users.sumner.extraGroups = [ "libvirtd" ];
    })

    (mkIf cfg.isServer {
      services.healthcheck.enable = true;
      boot.loader.timeout = 10;
      nix.gc.automatic = true;

      services.openssh.enable = true;
      services.openssh.permitRootLogin = "prohibit-password";

      # Enable LISH
      boot.kernelParams = [ "console=ttyS0,19200n8" ];
      boot.loader.grub.extraConfig = ''
        serial --speed=19200 --unit=0 --word=8 --party=no --stop=1;
        terminal_input serial;
        terminal_output serial;
      '';
    })
  ];
}
