{ pkgs, ... }:
{
  # See other configs:
  # * https://github.com/gpakosz/.newsboat/blob/master/config
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "${pkgs.xdg-utils}/bin/xdg-open";
    extraConfig = ''
      # Key navigation
      goto-next-feed no

      bind-key j down feedlist
      bind-key j next articlelist
      bind-key j down article
      bind-key J next-feed articlelist
      bind-key k up feedlist
      bind-key k prev articlelist
      bind-key k up article
      bind-key K prev-feed articlelist

      bind-key g home feedlist
      bind-key g home articlelist
      bind-key g home article
      bind-key G end feedlist
      bind-key G end articlelist
      bind-key G end article

      # View
      text-width 80

      # Newsboat colour scheme to work with the Nord palette
      # from Arctic Studios - https://github.com/arcticicestudio/nord
      # Tested with the iTerm2 Nord terminal colour scheme
      # https://github.com/arcticicestudio/nord-iterm2
      # though should work with any terminal using the palette

      color background          color236   default
      color listnormal          color248   default
      color listnormal_unread   color6     default
      color listfocus           color236   color12
      color listfocus_unread    color15    color12
      color info                color248   color236
      color article             color248   default

      # highlights
      highlight article "^(Feed|Link):.*$" color6 default bold
      highlight article "^(Title|Date|Author):.*$" color6 default bold
      highlight article "https?://[^ ]+" color10 default underline
      highlight article "\\[[0-9]+\\]" color10 default bold
      highlight article "\\[image\\ [0-9]+\\]" color10 default bold
      highlight feedlist "^─.*$" color6 color236 bold
    '';

    urls = [
      { url = "https://drewdevault.com/blog/index.xml"; }
      { url = "https://sourcehut.org/blog/index.xml"; }
      { url = "https://www.thedroneely.com/posts/rss.xml"; }
      { url = "https://stackoverflow.blog/feed/"; }
      { url = "https://jakevossen.libsyn.com/rss"; }
      { url = "https://emersion.fr/blog/rss.xml"; }
      { url = "https://www.joelonsoftware.com/feed/"; }
      { url = "https://weekly.nixos.org/feeds/all.rss.xml"; }
      { url = "https://veronneau.org/feeds/atom.xml"; }
    ];
  };
}
