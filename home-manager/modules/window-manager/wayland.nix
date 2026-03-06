{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.wayland;
in
{
  options = {
    wayland.enable = mkEnableOption "the Wayland stack";
    wayland.extraSwayConfig = mkOption {
      type = types.attrsOf types.anything;
      description = "Extra config for Sway";
      default = { };
    };
  };

  config = mkIf cfg.enable {
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
