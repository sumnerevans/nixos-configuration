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

  nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/pull/166901
    (
      self: super: {
        intel-ocl = super.intel-ocl.overrideAttrs (
          old: rec {
            src = fetchzip {
              # https://github.com/NixOS/nixpkgs/issues/166886
              urls = [
                "https://registrationcenter-download.intel.com/akdlm/irc_nas/11396/SRB5.0_linux64.zip"
                "http://registrationcenter-download.intel.com/akdlm/irc_nas/11396/SRB5.0_linux64.zip"
                "https://web.archive.org/web/20190526190814/http://registrationcenter-download.intel.com/akdlm/irc_nas/11396/SRB5.0_linux64.zip"
              ];
              sha256 = "0qbp63l74s0i80ysh9ya8x7r79xkddbbz4378nms9i7a0kprg9p2";
              stripRoot = false;
            };
          }
        );
      }
    )
  ];

  virtualisation.docker.enable = true;

  # Get sound working
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

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
