{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.wayland;
in
{
  options.wayland.enable = lib.mkEnableOption "the Wayland stack";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wl-clipboard ];

    programs.mpv.config = {
      gpu-context = "wayland";
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1";

      # Make IDEA work
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
  };
}
