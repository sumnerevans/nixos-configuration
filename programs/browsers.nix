{ config, pkgs, ... }: let
  chromeCommandLineArgs = "-high-dpi-support=0 -force-device-scale-factor=1";

  firefox = with pkgs; wrapFirefox firefox-unwrapped {
    extraExtensions = [
      (
        fetchFirefoxAddon {
          name = "ublock";
          url = "https://addons.mozilla.org/firefox/downloads/file/3679754/ublock_origin-1.31.0-an+fx.xpi";
          sha256 = "1h768ljlh3pi23l27qp961v1hd0nbj2vasgy11bmcrlqp40zgvnr";
        }
      )
      (
        fetchFirefoxAddon {
          name = "tree_style_tab";
          url = "https://addons.mozilla.org/firefox/downloads/file/3687872/tree_style_tab_-3.6.3-fx.xpi";
          sha256 = "5f09829d99955a59022d5dc247716dfcfbf49ef1f02037e4c25a1f929fcb271b";
        }
      )
    ];

    extraPolicies = {
      DisablePocket = true;
      DisableTelemetry = true;
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
      };
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };

    extraPrefs = ''
      // Show more ssl cert infos
      lockPref("security.identityblock.show_extended_validation", true);
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    (google-chrome.override { commandLineArgs = chromeCommandLineArgs; })
    elinks
    firefox
    w3m
  ];
}
