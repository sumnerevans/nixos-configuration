{ config, lib, pkgs, modulesPath, ... }:
{
  boot = {
    blacklistedKernelModules = [ "snd_hda_intel" "snd_soc_skl" ];
    # kernelPatches = [
    #   {
    #     name = "kohaku-sound";
    #     patch = null;
    #     extraConfig = ''
    #       SND_SOC_INTEL_DA7219_MAX98357A_GENERIC m
    #       SND_SOC_INTEL_CML_LP_DA7219_MAX98357A_MACH m
    #     '';
    #   }
    # ];
  };

  networking = {
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
