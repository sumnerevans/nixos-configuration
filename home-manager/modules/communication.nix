{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # rustPlatform.cargoSetupHook now forces -sys crates to link system libraries
  # (NixOS/nixpkgs#537108), so voxtype needs sqlite in buildInputs. nixpkgs'
  # voxtype was fixed in NixOS/nixpkgs#585434; remove this once the voxtype
  # flake adds sqlite too.
  withSqlite =
    p:
    p.overrideAttrs (old: {
      buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.sqlite ];
    });
in
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
        (withSqlite inputs.voxtype.packages.${pkgs.stdenv.hostPlatform.system}.osd-gtk4)
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
      text.spoken_punctuation = true;
    };
  };
}
