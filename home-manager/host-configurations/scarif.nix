{ pkgs, ... }:
{
  imports = [ ../home.nix ];

  wayland.enable = true;
  niri.enable = true;
  wayland.windowManager.hyprland.enable = true;
  dms.enable = true;

  mdf.port = 1024;

  home.packages = [ pkgs.pulseaudio ];

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs; [ obs-studio-plugins.wlrobs ];

}
