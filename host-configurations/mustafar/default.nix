{ lib, pkgs, ... }: with pkgs; let
  sof-firmware = callPackage ./intel-sof-firmware.nix {};
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
  nix.enableRemoteBuildOnCoruscant = true;
  nix.enableRemoteBuildOnTatooine = true;

  virtualisation.docker.enable = true;

  # Get sound working
  # hardware.firmware = [ sof-firmware ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  boot.blacklistedKernelModules = [ "snd_hda_intel" "snd_soc_skl" ];

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = linuxPackages_5_10;
  boot.kernelPatches = [
    {
      name = "chromebook-config";
      patch = null;
      extraConfig = ''
        CHROMEOS_LAPTOP m
        CHROMEOS_PSTORE m
        CHROME_PLATFORMS y
        CROS_EC m
        CROS_EC_CHARDEV m
        CROS_EC_DEBUGFS m
        CROS_EC_I2C m
        CROS_EC_LPC m
        CROS_EC_SENSORHUB m
        CROS_EC_SPI m
        CROS_EC_SYSFS m
        CROS_EC_TYPEC m
        CROS_USBPD_LOGGER m
        EXTCON_USBC_CROS_EC m
        I2C_CROS_EC_TUNNEL m
        IIO_CROS_EC_ACCEL_LEGACY m
        IIO_CROS_EC_BARO m
        IIO_CROS_EC_LIGHT_PROX m
        IIO_CROS_EC_SENSORS m
        IIO_CROS_EC_SENSORS_CORE m
        IIO_CROS_EC_SENSORS_LID_ANGLE m
        KEYBOARD_CROS_EC m
        RTC_DRV_CROS_EC m
        SND_SOC_CROS_EC_CODEC m
      '';
    }
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
