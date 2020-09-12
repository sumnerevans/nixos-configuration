{ config, pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    font-awesome_4
    iosevka
    noto-fonts
    noto-fonts-emoji
    powerline-fonts
    open-sans
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Iosevka Term"
      ];
      sansSerif = [
        "Open Sans"
      ];
      serif = [
        "Noto Serif"
      ];
    };
  };
}
