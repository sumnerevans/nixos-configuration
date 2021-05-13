{ config, lib, pkgs, ... }: with lib; let
  bootloaderCfg = config.boot.loader;
in
{
  options.bootloader = {
    grub.enable = mkEnableOption "the GRUB bootloader";
    systemd-boot.enable = mkEnableOption "the systemd-boot bootloader";
  };

  config = mkMerge [
    {
      boot.cleanTmpDir = true;
    }

    # If GRUB is selected in the host configuration, then add the following
    # options.
    (mkIf bootloaderCfg.grub.enable {
      boot.loader.grub = {
        forceInstall = true;
        device = "nodev";
      };
    })

    # If systemd-boot is selected in the host configuration, then add the
    # following options.
    (mkIf bootloaderCfg.systemd-boot.enable {
      boot.loader.efi.canTouchEfiVariables = true;
    })
  ];
}
