{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with pkgs;
let
  hasGui = config.wayland.enable || config.xorg.enable;
in
{
  options.gaming.enable = mkEnableOption "gaming programs";

  config = {
    home.packages = [
      # Shell Utilities
      ffmpeg-full
      yt-dlp
    ]
    ++ (
      # GUI Tools
      optionals hasGui [
        pavucontrol
        playerctl

        # Multimedia
        fbida
        gimp
        imagemagick
        inkscape
        # kdePackages.kdenlive
        # libreoffice
        # spotify
        pear-desktop
      ]
    );

    programs.feh.enable = true;

    programs.mpv.enable = hasGui;
    programs.mpv.config = {
      force-window = "yes";
      hwdec = "auto-safe";
      profile = "gpu-hq";
      vo = "gpu";
      ytdl-format = "bestvideo+bestaudio";
    };

    programs.obs-studio.enable = hasGui;
    programs.obs-studio.plugins = with pkgs; [ obs-studio-plugins.wlrobs ];

    programs.zathura.enable = hasGui;
  };
}
