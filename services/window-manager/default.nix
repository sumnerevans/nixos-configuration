{ config, lib, pkgs, ... }: let
  editor = "nvim";
  terminal = "alacritty";
  useSway = (lib.removeSuffix "\n" (builtins.readFile ./usesway)) == "Y";
in
{
  # Import the correct configs.
  imports = if useSway then [ ./sway.nix ] else [ ./i3wm.nix ];

  # Add some environment variables for when things get fired up with shortcuts
  # in i3/sway.
  environment.variables = {
    VISUAL = "${editor}";
    EDITOR = "${editor}";
    TERMINAL = "${terminal}";

    # Enable touchscreen and Wayland in Firefox
    MOZ_USE_XINPUT2 = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # For piping video capture of the screen back to a video output.
  # boot.extraModulePackages = [
  #   pkgs.linuxPackages.v4l2loopback
  # ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  # hardware.pulseaudio = {
  #   enable = true;
  #   support32Bit = true;

  #   # Use pulseaudioFull because it has Bluetooth support.
  #   package = pkgs.pulseaudioFull;
  # };

  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
    package = lib.mkIf useSway pkgs.redshift-wlr;
    extraOptions = lib.mkIf useSway [ "-m wayland" ];

    brightness = {
      day = "1";
      night = "0.9";
    };

    temperature = {
      day = 5500;
      night = 4000;
    };
  };

  systemd.user.services.redshift = { ... }: {
    options = {
      serviceConfig = lib.mkOption {
        apply = opts: opts // {
          ExecStart = builtins.replaceStrings [ "/bin/redshift" ] [ "/bin/redshift-gtk" ] opts.ExecStart;
        };
      };
    };
    config = {};
  };
}
