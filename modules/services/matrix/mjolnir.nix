{ config, lib, pkgs, ... }: with lib; let
  mjolnirCfg = config.services.mjolnir;
in
{
  services.mjolnir = {
    homeserverUrl = "https://matrix.nevarro.space";

    pantalaimon = {
      enable = true;
      username = "marshal";
      passwordFile = "/etc/nixos/secrets/matrix/bots/marshal";
      options = {
        listenAddress = "127.0.0.1";
        listenPort = 8100;
      };
    };

    managementRoom = "#mjolnir:nevarro.space";

    settings = {
      protectAllJoinedRooms = true;
    };
  };
  services.pantalaimon-headless.instances = mkIf mjolnirCfg.enable {
    mjolnir = {
      listenAddress = "127.0.0.1";
      listenPort = 8100;
    };
  };
}
