{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = (
    lib.optionals (config.wayland.enable || config.xorg.enable) (
      with pkgs;
      [
        discord
        element-desktop
        mumble
        zoom-us
      ]
    )
  );
}
