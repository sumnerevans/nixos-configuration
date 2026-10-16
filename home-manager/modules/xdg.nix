{ lib, ... }:
let
  imageMimeTypes = [
    "image/bmp"
    "image/gif"
    "image/heic"
    "image/jpeg"
    "image/jpg"
    "image/pjpeg"
    "image/png"
    "image/tiff"
    "image/webp"
    "image/x-bmp"
    "image/x-pcx"
    "image/x-png"
    "image/x-portable-anymap"
    "image/x-portable-bitmap"
    "image/x-portable-graymap"
    "image/x-portable-pixmap"
    "image/x-tga"
    "image/x-xbitmap"
  ];
in
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = lib.genAttrs imageMimeTypes (_: "feh.desktop") // {
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "text/html" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
      };
      associations.added = {
        "image/jpeg" = "feh.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/chrome" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
      };
    };
  };
}
