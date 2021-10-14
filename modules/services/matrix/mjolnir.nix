{ config, lib, pkgs, ... }: with lib; let
  mjolnirCfg = config.services.mjolnir;
in
{
  imports = [
    ./mjolnir-pr-123896/modules/matrix/mjolnir.nix
    ./mjolnir-pr-123896/modules/matrix/pantalaimon.nix
  ];

  nixpkgs.overlays = [
    (self: super: {
      mjolnir = self.callPackage ./mjolnir-pr-123896/pkgs/mjolnir { };
      pantalaimon-headless = self.pantalaimon.overridePythonAttrs {
        propagatedBuildInputs = with pkgs.python3Packages; [
          aiohttp
          appdirs
          attrs
          click
          janus
          keyring
          Logbook
          matrix-nio
          peewee
          prompt-toolkit
          setuptools
        ];
      };
    })
  ];

  services.mjolnir = {
    homeserverUrl = "http://localhost:8008";

    pantalaimon = {
      enable = true;
      username = "marshal";
      passwordFile = "/etc/nixos/secrets/matrix/bots/marshal";
      options.listenPort = 8100;
    };

    managementRoom = "#mjolnir:nevarro.space";

    settings = {
      protectAllJoinedRooms = true;
    };
  };
}
