{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  hasGui = config.wayland.enable || config.xorg.enable;
in
{
  home.packages = with pkgs; [
    elinks
    w3m
  ];

  programs.google-chrome.enable = hasGui;
  programs.brave = {
    enable = hasGui;
    commandLineArgs = [ "--enable-features=TouchpadOverscrollHistoryNavigation" ];
  };
  programs.chromium.enable = hasGui;
  programs.firefox.enable = hasGui;

  home.sessionVariables = lib.mkIf hasGui {
    # Enable touchscreen in Firefox
    MOZ_USE_XINPUT2 = "1";
    MOZ_DBUS_REMOTE = "1";
  };
}
