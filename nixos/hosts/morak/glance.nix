{ config, ... }:
{
  services.glance = {
    enable = true;
    settings = {
      server.port = 5678;
      pages = [
        {
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "rss";
                  title = "Following";
                  style = "detailed-list";
                  collapse-after = 8;
                  feeds = [
                    { url = "https://blog.babel.sh/rss/"; }
                    { url = "https://blog.beeper.com/feed/"; }
                    { url = "https://blog.danslimmon.com/feed/"; }
                    { url = "https://byronsharman.com/blog.xml"; }
                    { url = "https://chriskiehl.com/rss.xml"; }
                    { url = "https://chrismcdonough.substack.com/feed"; }
                    { url = "https://chrpaul.de/index.xml"; }
                    { url = "https://dominickm.com/feed/"; }
                    { url = "https://elijahpotter.dev/rss.xml"; }
                    { url = "https://ericmigi.com/rss.xml"; }
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
                    { url = "https://matrix.org/atom.xml"; }
                    { url = "https://mau.fi/blog/index.rss"; }
                    { url = "https://medium.com/feed/@ericmigi"; }
                    { url = "https://nathanieljwright.com/feed/"; }
                    { url = "https://neilalexander.dev/feed.xml"; }
                    { url = "https://pointlessramblings.com/index.xml"; }
                    { url = "https://skip.house/rss.xml"; }
                    { url = "https://textslashplain.com/feed/"; }
                    { url = "https://tgrcode.com/rss"; }
                    { url = "https://weekly.nixos.org/feeds/all.rss.xml"; }
                    { url = "https://www.arp242.net/feed.xml"; }
                    { url = "https://www.edna.land/blogs/index.xml"; }
                    { url = "https://www.joelonsoftware.com/feed/"; }
                    { url = "https://www.micahbird.com/index.xml"; }
                    { url = "https://www.seangoedecke.com/rss.xml"; }
                    { url = "https://www.thedroneely.com/posts/rss.xml"; }
                    { url = "https://www.wheresyoured.at/rss/"; }
                  ];
                }
              ];
            }
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
                  type = "weather";
                  units = "imperial";
                  hour-format = "24h";
                  location = "Denver, Colorado, United States";
                }
              ];
            }
          ];
          name = "Home";
        }
      ];
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."glance.sumnerevans.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass =
        "http://${config.services.glance.settings.server.host}:${toString config.services.glance.settings.server.port}";
    };
  };
}
