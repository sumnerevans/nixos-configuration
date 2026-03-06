{ lib, ... }:
{
  programs.alacritty = {
    enable = true;
    theme = "one_dark";
    settings = {
      window.title = "Terminal";
      font.size = lib.mkDefault 10;
    };
  };
}
