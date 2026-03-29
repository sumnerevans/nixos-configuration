{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.hostCategory == "laptop") {
    environment.homeBinInPath = true;
    services.upower.enable = true;

    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 25;
      efi.canTouchEfiVariables = true;
    };

    fileSystems = {
      # Temporary in-RAM Filesystems.
      "/home/sumner/tmp" = {
        fsType = "tmpfs";
        options = [
          "nosuid"
          "nodev"
          "size=${toString config.ramSize}G"
        ];
      };
    };

    networking.networkmanager.enable = true;
    networking.usePredictableInterfaceNames = true;
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

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
    services.logind.settings.Login.HandlePowerKey = "suspend";

    # Enable Flatpak.
    services.flatpak.enable = true;
    xdg.portal.enable = true;

    # Enable YubiKey smart card mode.
    services.pcscd.enable = true;

    # Enable firmware updating
    services.fwupd.enable = true;

    # Enable libvirtd and virt-manager
    virtualisation.libvirtd.enable = true;
    users.users.sumner.extraGroups = [ "libvirtd" ];

    # For flashing ErgoDox and Voyager.
    hardware.keyboard.zsa.enable = true;

    # Extra programs for laptops
    environment.systemPackages = with pkgs; [
      virt-manager
      android-tools
      lm_sensors
    ];
  };
}
