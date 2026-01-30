{ config, lib, ... }:
with lib;
let cfg = config.services.glance;
in mkIf cfg.enable {
  services.glance = {
    settings = {
      server.port = 5678;
      pages = [{
        columns = [
          {
            size = "small";
            widgets = [
              {
                type = "clock";
                hour-format = "24h";
                timezones = [
                  {
                    timezone = "Etc/UTC";
                    label = "UTC";
                  }
                  {
                    timezone = "Europe/Helsinki";
                    label = "Helsinki";
                  }
                ];
              }
              { type = "calendar"; }
              {
                type = "bookmarks";
                groups = [
                  {
                    title = "Beeper";
                    links = [
                      {
                        title = "Linear";
                        url = "https://linear.app";
                      }
                      {
                        title = "Admin";
                        url = "https://admin.beeper.com";
                      }
                      {
                        title = "Grafana";
                        url = "https://grafana.beeper-tools.com";
                      }
                    ];
                  }
                  {
                    title = "Financial";
                    links = [
                      {
                        title = "Fidelity";
                        url = "https://digital.fidelity.com";
                      }
                      {
                        title = "Robinhood";
                        url = "https://robinhood.com";
                      }
                      {
                        title = "CapitalOne";
                        url = "https://capitalone.com";
                      }
                      {
                        title = "Chase";
                        url = "https://chase.com";
                      }
                      {
                        title = "Discover";
                        url = "https://discover.com";
                      }
                    ];
                  }
                  {
                    title = "Vanity";
                    links = [
                      {
                        title = "GoatCounter";
                        url = "https://sws.goatcounter.com";
                      }
                      {
                        title = "LinkedIn";
                        url = "https://linkedin.com";
                      }
                    ];
                  }
                ];
              }
            ];
          }
          {
            size = "full";
            widgets = [{
              type = "rss";
              title = "Following";
              style = "detailed-list";
              collapse-after = 8;
              feeds = [
                { url = "https://b-sharman.dev/blog.xml"; }
                { url = "https://blog.babel.sh/rss"; }
                { url = "https://blog.beeper.com/feed"; }
                { url = "https://blog.danslimmon.com/feed"; }
                { url = "https://chriskiehl.com/rss.xml"; }
                { url = "https://chrismcdonough.substack.com/feed"; }
                { url = "https://chrpaul.de/feed.xml"; }
                { url = "https://dominickm.com/feed"; }
                { url = "https://elijahpotter.dev/rss.xml"; }
                { url = "https://ezrichards.github.io/index.xml"; }
                { url = "https://go.dev/blog/feed.atom"; }
                { url = "https://intuitiveexplanations.com/feed.xml"; }
                { url = "https://jjtech.dev/feed.xml"; }
                { url = "https://jsomers.net/blog/feed"; }
                { url = "https://jvns.ca/atom.xml"; }
                { url = "https://keenanschott.com/index.xml"; }
                { url = "https://ludic.mataroa.blog/rss/"; }
                { url = "https://lukaswerner.com/feed.xml"; }
                { url = "https://lukeplant.me.uk/blog/atom/index.xml"; }
                { url = "https://machinefossil.net/feed.xml"; }
                { url = "https://matrix.org/blog/feed"; }
                { url = "https://mau.fi/blog/index.rss"; }
                { url = "https://medium.com/feed/@ericmigi"; }
                { url = "https://neilalexander.dev/feed.xml"; }
                { url = "https://pointlessramblings.com/index.xml"; }
                { url = "https://skip.house/rss.xml"; }
                { url = "https://textslashplain.com/feed/"; }
                { url = "https://tgrcode.com/rss"; }
                { url = "https://weekly.nixos.org/feeds/all.rss.xml"; }
                { url = "https://www.arp242.net/feed.xml"; }
                { url = "https://www.joelonsoftware.com/feed/"; }
                { url = "https://www.thedroneely.com/posts/rss.xml"; }
                { url = "https://www.wheresyoured.at/rss/"; }
              ];
            }];
          }
          {
            size = "small";
            widgets = [
              {
                type = "monitor";
                title = "Services";
                sites = [
                  {
                    title = "sumnerevans.com";
                    url = "https://sumnerevans.com";
                    icon =
                      "https://sumnerevans.com/profile_hu10331672011849843701.webp";
                  }
                  {
                    title = "nevarro.space";
                    url = "https://nevarro.space";
                    icon = "https://nevarro.space/n1-square.jpg";
                  }
                  {
                    title = "Matrix";
                    url =
                      "https://matrix.nevarro.space/_matrix/client/versions";
                    icon = "si:matrix";
                  }
                ];
              }
              {
                type = "weather";
                units = "imperial";
                hour-format = "24h";
                location = "Denver, Colorado, United States";
              }
            ];
          }
        ];
        name = "Home";
      }];
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."glance.sumnerevans.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = let
        host = cfg.settings.server.host;
        port = toString cfg.settings.server.port;
      in "http://${host}:${port}";
    };
  };
}
