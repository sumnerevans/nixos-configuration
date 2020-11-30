{ config, lib, pkgs, modulesPath, ... }: with pkgs; let
  sof-firmware = callPackage ./intel-sof-firmware.nix {};
in
{
  # Get sound working
  # hardware.firmware = [ sof-firmware ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  boot.blacklistedKernelModules = [ "snd_hda_intel" "snd_soc_skl" ];

  # Orientation and ambient light
  hardware.sensor.iio.enable = true;

  networking = {
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
