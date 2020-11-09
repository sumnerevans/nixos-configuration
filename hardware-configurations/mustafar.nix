{ config, lib, pkgs, modulesPath, ... }:
{
  boot.blacklistedKernelModules = [ "snd_hda_intel" ];
  boot.kernelModules = [ "snd_soc_skl" ];

  networking = {
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
