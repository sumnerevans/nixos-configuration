{ lib, pkgs, ... }: with pkgs; let
  logrotateLib = import ../../lib/logrotate.nix;
in
{
  # Set the hostname
  networking.hostName = "mustafar";
  hardware.isPC = true;
  hardware.ramSize = 8;
  hardware.isLaptop = true;
  wayland.enable = true;

  virtualisation.docker.enable = true;

  # Get sound working
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = linuxPackages_5_10;

  # Orientation and ambient light
  hardware.sensor.iio.enable = true;

  # Set up networking.
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  # Intel's libva driver
  hardware.opengl.extraPackages = [
    intel-media-driver
    vaapiVdpau
    libvdpau-va-gl
    intel-ocl
  ];
  environment.systemPackages = [ libva-utils ];
}
