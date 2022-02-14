{ config, lib, pkgs, ... }: {
  nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/pull/159074
    (self: super: {
      remarshal = super.remarshal.overrideAttrs (old: rec {
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace "poetry.masonry.api" "poetry.core.masonry.api" \
            --replace 'PyYAML = "^5.3"' 'PyYAML = "*"' \
            --replace 'tomlkit = "^0.7"' 'tomlkit = "*"'
        '';
      });
    })
  ];

  fonts = lib.mkIf (config.xorg.enable || config.wayland.enable) {
    fonts = with pkgs; [
      font-awesome_4
      iosevka
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
