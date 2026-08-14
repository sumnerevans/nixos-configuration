{
  config,
  lib,
  pkgs,
  ...
}:
let
  hasGui = config.wayland.enable || config.xorg.enable;
in
{
  home.packages = with pkgs; [
    w3m
  ];

  programs.google-chrome.enable = hasGui;
  # programs.brave = {
  #   enable = hasGui;
  #   commandLineArgs = [ "--enable-features=TouchpadOverscrollHistoryNavigation" ];
  # };
  programs.chromium.enable = hasGui;

  programs.firefox = lib.mkIf hasGui {
    enable = true;
    profiles.default = {
      id = 0;
      isDefault = true;
      path = "default";

      # Curated from the pre-existing profile's prefs.js: only prefs that are
      # local-only (not in services.sync.prefs.sync-seen.*) are pinned here, so
      # this doesn't fight with Firefox Sync's cross-device pref sync.
      settings = {
        "browser.download.dir" = "/home/sumner/tmp";
        "browser.download.folderList" = 2;
        "browser.toolbars.bookmarks.visibility" = "always";
        "devtools.toolbox.host" = "right";
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        ctrl-number-to-switch-tabs
        enhancer-for-youtube
        read-aloud
        return-youtube-dislikes
      ];
    };
  };

  home.sessionVariables = lib.mkIf hasGui {
    # Enable touchscreen in Firefox
    MOZ_USE_XINPUT2 = "1";
    MOZ_DBUS_REMOTE = "1";
  };
}
