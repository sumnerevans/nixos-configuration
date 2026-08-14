{
  config,
  lib,
  pkgs,
  ...
}:
let
  hasGui = config.wayland.enable || config.xorg.enable;

  # https://danklinux.com/docs/dankmaterialshell/application-themes#option-1-material-fox-chrome-like-with-dynamic-colors
  # theme-material-blue.css is replaced with a symlink to DMS's matugen-generated
  # firefox.css so the theme's colors follow the system theme dynamically.
  materialFoxChrome = pkgs.runCommand "material-fox-chrome" { } ''
    cp -r ${
      pkgs.fetchzip {
        url = "https://github.com/edelvarden/material-fox-updated/releases/download/v2.0.0/chrome.zip";
        hash = "sha256-0o1kCjX5Z1bO78/6Qx94WdXv93YLsATeritw5gcQ2jo=";
      }
    } $out
    chmod -R u+w $out
    ln -sf ${config.home.homeDirectory}/.config/DankMaterialShell/firefox.css $out/theme-material-blue.css
  '';
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

        # Material Fox (Chrome-like theme with dynamic Material You colors)
        "toolkit.legacyuserprofilecustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "userChrome.theme-material" = true;
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

  home.file.".mozilla/firefox/default/chrome" = lib.mkIf hasGui {
    source = materialFoxChrome;
    recursive = true;
    force = true;
  };

  home.sessionVariables = lib.mkIf hasGui {
    # Enable touchscreen in Firefox
    MOZ_USE_XINPUT2 = "1";
    MOZ_DBUS_REMOTE = "1";
  };
}
