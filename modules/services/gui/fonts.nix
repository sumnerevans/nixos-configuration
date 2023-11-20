{ config, lib, pkgs, ... }: {
  fonts = lib.mkIf config.programs.sway.enable {
    packages = with pkgs; [
      font-awesome_4
      iosevka-bin
      noto-fonts
      noto-fonts-emoji
      open-sans
      powerline-fonts
      terminus-nerdfont
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka" "Font Awesome" ];
        sansSerif = [ "Open Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}
