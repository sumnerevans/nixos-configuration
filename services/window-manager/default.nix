{ config, lib, pkgs, ... }: let
  editor = "${pkgs.neovim}/bin/nvim";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  useSway = (lib.removeSuffix "\n" (builtins.readFile ./usesway)) == "Y";
in
{
  # Import the correct configs.
  imports = [ ./i3wm.nix ] ++ (if useSway then [ ./sway.nix ] else [ ./picom.nix ]);

  services.xbanish.enable = !useSway;

  environment.systemPackages = with pkgs; [
    arc-icon-theme
    arc-theme
    brightnessctl
    gnome-breeze
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

  # Must have this for redshift or gammastep.
  location.provider = "geoclue2";
}
