{ config, lib, pkgs, ... }: with lib; let
  bootloaderCfg = config.boot.loader;
in
{
  boot.cleanTmpDir = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  boot.loader.efi.canTouchEfiVariables = true;
}
