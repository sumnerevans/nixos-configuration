{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  mineshspcAdmin = {
    name = "MinesHSPC-Admin";
    address = "admin@mineshspc.com";
    color = "green";
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts = {
    MinesHSPC-Admin = mkMerge [
      (helper.commonConfig mineshspcAdmin)
      (helper.imapnotifyConfig mineshspcAdmin)
      { flavor = "migadu.com"; }
    ];
  };
}
