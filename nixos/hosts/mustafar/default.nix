{
  lib,
  pkgs,
  ...
}:
let
  # This is a Google Kohaku board (Samsung Galaxy Chromebook). Its sound
  # card (sof-cmlda7219max, an Intel SOF/DA7219/MAX98357A setup) is detected
  # fine by the kernel, but nixpkgs' alsa-ucm-conf doesn't ship a UCM profile
  # for it, so PipeWire falls back to the generic ACP profile, which only
  # exposes a non-functional "Dummy Output"/"Pro Audio" device. Chrultrabook's
  # chromebook-linux-audio project (https://github.com/WeirdTreeThing/chromebook-linux-audio)
  # solves this on other distros by overlaying downstream UCM profiles from
  # https://github.com/WeirdTreeThing/alsa-ucm-conf-cros on top of the
  # system's UCM configuration. Replicate that here by merging those profiles
  # on top of pkgs.alsa-ucm-conf and pointing PipeWire/WirePlumber at the result.
  alsaUcmConfCros = pkgs.fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "alsa-ucm-conf-cros";
    rev = "4828c1ddb1c2d8a54d031f682ca08c5af20b1870"; # standalone branch
    hash = "sha256-T3X5GqFq924CcZ5WL7hE/ciRi7HplF99vatEjDJik3U=";
  };

  alsaUcmConfChromebook = pkgs.runCommand "alsa-ucm-conf-chromebook" { } ''
    mkdir -p $out/share/alsa/ucm2
    cp -r ${pkgs.alsa-ucm-conf}/share/alsa/ucm2/. $out/share/alsa/ucm2/
    chmod -R u+w $out/share/alsa/ucm2
    cp -r ${alsaUcmConfCros}/ucm2/. $out/share/alsa/ucm2/
    cp -r ${alsaUcmConfCros}/overrides/. $out/share/alsa/ucm2/conf.d/
    chmod -R u+w $out/share/alsa/ucm2

    # The ported "Headphones" device only flips the jack/headphone-amp
    # switches, leaving the DA7219's DAC digital mute and its output-filter
    # mixer switches off, so no audio actually reaches the jack (only a
    # faint whine from the charge pump). Enable them alongside the switches
    # it already sets, and restore the mute on disable.
    hifiConf=$out/share/alsa/ucm2/conf.d/sof-cmlda7219ma/HiFi.conf
    sed -i \
      -e "s/cset \"name='Headphone Switch' on\"/cset \"name='Headphone Switch' on\"\n\t\tcset \"name='Playback Digital Switch' on,on\"\n\t\tcset \"name='Mixer Out FilterL DACL Switch' on\"\n\t\tcset \"name='Mixer Out FilterR DACR Switch' on\"/" \
      -e "s/cset \"name='Headphone Switch' off\"/cset \"name='Headphone Switch' off\"\n\t\tcset \"name='Playback Digital Switch' off,off\"\n\t\tcset \"name='Mixer Out FilterL DACL Switch' off\"\n\t\tcset \"name='Mixer Out FilterR DACR Switch' off\"/" \
      "$hifiConf"
    grep -q "Mixer Out FilterL DACL Switch' on" "$hifiConf"
    grep -q "Mixer Out FilterL DACL Switch' off" "$hifiConf"
  '';
  alsaConfigUcm2 = "${alsaUcmConfChromebook}/share/alsa/ucm2";
in
{
  # Set the hostname
  networking.hostName = "mustafar";

  hostCategory = "laptop";
  ramSize = 8;

  virtualisation.docker.enable = true;

  # This machine has no fan, so let thermald throttle the CPU proactively
  # based on the board's thermal zones instead of relying on emergency
  # kernel throttling once it's already too hot.
  services.thermald.enable = true;

  # Get sound working
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # Point ALSA/PipeWire/WirePlumber at the merged UCM profiles (see
  # alsaUcmConfChromebook above) so the sof-cmlda7219max card gets a real
  # HiFi profile instead of falling back to ACP's "Dummy Output".
  environment.sessionVariables.ALSA_CONFIG_UCM2 = alsaConfigUcm2;
  systemd.user.services.pipewire.environment.ALSA_CONFIG_UCM2 = alsaConfigUcm2;
  systemd.user.services.wireplumber.environment.ALSA_CONFIG_UCM2 = alsaConfigUcm2;

  # Recommended alongside the UCM fix above: increases ALSA headroom, which
  # chromebook-linux-audio applies to fix instability/crashes on these SOF
  # sound cards.
  services.pipewire.wireplumber.extraConfig."51-increase-headroom" = {
    "monitor.alsa.rules" = [
      {
        matches = [ { "node.name" = "~alsa_output.*"; } ];
        actions.update-props."api.alsa.headroom" = 2048;
      }
    ];
  };

  # The greeter runs its own Hyprland instance; use the ChromeOS variant of
  # the 3l layout to match this machine's built-in keyboard (see laptop.nix
  # for the default).
  dmsGreeterKeyboardVariant = "3l-cros";

  # Use systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # The touchpad (i2c-PNP0C50:00) is enabled as an S3 wakeup source by
  # default, and its wake IRQ fires spuriously right after suspend,
  # immediately waking the machine back up. Disable it so only the lid
  # switch can wake the system.
  services.udev.extraRules = ''
    SUBSYSTEM=="i2c", KERNELS=="i2c-PNP0C50:00", ATTR{power/wakeup}="disabled"
  '';

  # Orientation and ambient light
  hardware.sensor.iio.enable = true;

  # Set up networking.
  networking.interfaces.wlp0s20f3.useDHCP = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/84c203a4-3277-4884-8f22-b49187480eb9";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CFB2-2BBA";
    fsType = "vfat";
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/da9b8ec9-6432-4e40-b621-433c1634b728";
    fsType = "ext4";
  };

  # zram is tried first (high priority, RAM-speed); the swapfile is a slower
  # disk-backed backstop for when zram fills up, so systemd-oomd's
  # memory-pressure signal degrades gracefully instead of triggering a kill
  # (usually Firefox, as the biggest memory consumer) the moment RAM is tight.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8192;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
