{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    font = "pango:Iosevka 12";
    location = "top";
    terminal = "${pkgs.kitty}/bin/kitty";
    yoffset = 80;
    extraConfig = {
      matching = "fuzzy";
    };

    theme = "Arc-Dark";
    pass.enable = true;
  };
}
