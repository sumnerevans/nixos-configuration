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

        gradia # Annotate images

        # Multimedia
        fbida
        gimp
        imagemagick
        inkscape
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

    programs.zathura.enable = hasGui;
  };
}
