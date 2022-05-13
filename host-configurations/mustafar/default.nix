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
    # sof-firmware so sleep works on Kohaku
    (
      self: super: {
        sof-firmware = super.sof-firmware.overrideAttrs (
          old: rec {
            version = "1.5.1";
            src = super.fetchFromGitHub {
              owner = "thesofproject";
              repo = "sof-bin";
              rev = "ae61d2778b0a0f47461a52da0d1f191f651e0763";
              sha256 = "0j6bpwz49skvdvian46valjw4anwlrnkq703n0snkbngmq78prba";
            };

            installPhase = ''
              mkdir -p $out/lib/firmware/intel
              sed -i 's/ROOT=.*$/ROOT=$out/g' go.sh
              sed -i 's/VERSION=.*$/VERSION=v${version}/g' go.sh
              ./go.sh
            '';
          }
        );
      }
    )
  ];
  # nix.enableRemoteBuildOnCoruscant = true;
  # nix.enableRemoteBuildOnTatooine = true;

  virtualisation.docker.enable = true;

  # Get sound working
  # hardware.firmware = [ sof-firmware ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  boot.blacklistedKernelModules = [ "snd_hda_intel" "snd_soc_skl" ];

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
