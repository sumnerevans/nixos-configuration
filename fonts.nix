{ config, pkgs, ... }:
{
  fonts = {
    fonts = with pkgs; [
      font-awesome_4
      iosevka
      nerdfonts
      noto-fonts
      noto-fonts-emoji
      open-sans
      powerline-fonts
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "Iosevka"
          "Font Awesome"
        ];
        sansSerif = [
          "Open Sans"
        ];
        serif = [
          "Noto Serif"
        ];
      };
    };
  };
}
