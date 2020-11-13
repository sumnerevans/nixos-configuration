{ pkgs, ... }:
{
  environment.variables = {
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # nixpkgs.overlays = [
  #   (
  #     self: super: {
  #       mako = super.mako.overrideAttrs (
  #         old: {
  #           version = "1.4.2pre";
  #           src = self.fetchFromGitHub {
  #             owner = "emersion";
  #             repo = "mako";
  #             rev = "master";
  #             sha256 = "1qcpl6kpz97h6960kh0cnc3cky07s3brmhw5pjyaayrgipk3n0iq";
  #           };
  #         }
  #       );
  #     }
  #   )
  # ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr ];
    gtkUsePortal = true;
  };

  # Make sway the graphical-session target.
  systemd.user.targets.sway-session = {
    description = "sway window manager session";
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      clipman
      glib # for GTK settings
      gnome3.networkmanagerapplet
      grim
      mako # notification daemon
      slurp
      swaylock-effects # lockscreen
      v4l-utils
      waybar # status bar
      wf-recorder
      wl-clipboard # clipboard management
      wofi
      xdg_utils
      xwayland # for legacy apps
    ];
  };
}
