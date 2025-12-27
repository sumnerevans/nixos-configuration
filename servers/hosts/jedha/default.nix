{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  deployment.keys = let
    keyFor = keyname: for: {
      keyCommand = [ "cat" "secrets/${keyname}" ];
      user = for;
      group = for;
    };
  in { };

  networking.hostName = "jedha";
}
