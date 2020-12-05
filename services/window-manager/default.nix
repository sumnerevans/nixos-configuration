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

  services.xbanish.enable = !useSway;

  environment.systemPackages = with pkgs; [
    arc-icon-theme
    arc-theme
    brightnessctl
    gnome-breeze
    i3status-rust
    rofi
    rofi-pass
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

  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
    package = lib.mkIf useSway pkgs.redshift-wlr;
    executable = "/bin/redshift-gtk";
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
}
