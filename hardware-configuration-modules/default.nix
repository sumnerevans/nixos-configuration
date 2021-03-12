#
# Contains convenience modules for configuring the hardware.
#
{ pkgs, ... }: {
  imports = [
    ./bluetooth.nix
    ./power-management.nix
    ./tmpfs.nix
    ./v4l2loopback.nix
  ];

  networking = {
    networkmanager = {
      enable = true;
      enableStrongSwan = true;
    };

    firewall.enable = false;

    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so this
    # generated config replicates the default behaviour.
    useDHCP = false;
  };

  # Enable sound.
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    # pulse.enable = true;
  };
}
