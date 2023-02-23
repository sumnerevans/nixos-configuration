{ config, lib, pkgs, ... }: with lib; let
  bootloaderCfg = config.boot.loader;
in
{
  boot.cleanTmpDir = true;
  boot.loader.grub.devices = [ "/dev/sda" ];

  boot.loader.grub.configurationLimit = 25;
  boot.loader.systemd-boot.configurationLimit = 25;

  boot.loader.efi.canTouchEfiVariables = true;
}
