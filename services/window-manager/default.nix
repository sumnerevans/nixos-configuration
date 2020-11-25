{ config, lib, pkgs, ... }: let
  editor = "${pkgs.neovim}/bin/nvim";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  useSway = (lib.removeSuffix "\n" (builtins.readFile ./usesway)) == "Y";
in
{
  # Import the correct configs.
  imports = [
    ./i3wm.nix
  ] ++ (
    if useSway then [
      ./sway.nix
    ] else [
      ./picom.nix
    ]
  );

  environment.systemPackages = with pkgs; [
    brightnessctl
    i3status-rust
    screenkey
  ];

  # Add some environment variables for when things get fired up with shortcuts
  # in i3/sway.
  environment.variables = {
    VISUAL = "${editor}";
    EDITOR = "${editor}";
    TERMINAL = "${terminal}";

    # Enable touchscreen in Firefox
    MOZ_USE_XINPUT2 = "1";
  };

  # For piping video capture of the screen back to a video output.
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
  };

  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
    package = lib.mkIf useSway pkgs.redshift-wlr;
    extraOptions = lib.mkIf useSway [ "-m" "wayland" ];

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
