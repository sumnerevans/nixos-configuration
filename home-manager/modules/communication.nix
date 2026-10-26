{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = lib.optionals (config.wayland.enable || config.xorg.enable) [
    pkgs.discord
    pkgs.mumble
  ];

  services.voxtype = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "voxtype";
      meta.mainProgram = "voxtype";
      paths = [
        pkgs.voxtype-vulkan
        inputs.voxtype.packages.${pkgs.stdenv.hostPlatform.system}.osd-gtk4
      ];
    };
    loadModels = [ "base.en" ];
    wayland.display = "wayland-1";
    environment.PATH = lib.makeBinPath [
      config.services.voxtype.package
      pkgs.coreutils
      pkgs.which
      pkgs.wl-clipboard
      pkgs.wtype
    ];
    settings = {
      hotkey.enabled = false;
      osd.frontend = "gtk4";
      whisper = {
        language = "en";
        translate = false;
      };
      output = {
        mode = "type";
        fallback_to_clipboard = true;
        pre_type_delay_ms = 100;
        notifications.on_transcription = false;
      };
    };
  };
}
