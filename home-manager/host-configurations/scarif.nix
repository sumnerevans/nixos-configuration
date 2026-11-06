{ pkgs, ... }:
{
  imports = [ ../home.nix ];

  wayland.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    monitorScale = 1.5;
    # The panel advertises HDR10 but is a 700-nit sRGB LCD without local
    # dimming. Auto-HDR only causes a modeset (black flash) on fullscreen.
    settings.config.render.cm_auto_hdr = 0;
  };
  dms.enable = true;

  mdf.port = 1024;

  home.packages = [ pkgs.pulseaudio ];

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
}
