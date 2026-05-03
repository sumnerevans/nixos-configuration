{ pkgs, ... }:
{
  imports = [ ../home.nix ];

  wayland.enable = true;
  niri.enable = true;
  dms.enable = true;

  mdf.port = 1024;

  home.packages = [ pkgs.pulseaudio ];
}
