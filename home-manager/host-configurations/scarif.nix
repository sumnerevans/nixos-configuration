{ pkgs, ... }:
{
  imports = [ ../home.nix ];

  wayland.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    monitorScale = 1.5;
  };
  dms.enable = true;

  mdf.port = 1024;

  home.packages = [ pkgs.pulseaudio ];

  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
}
