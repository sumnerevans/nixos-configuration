{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  commentsConfig = {
    name = "Comments";
    address = "comments@sumnerevans.com";
    color = "green";
  };

  junkConfig = {
    name = "Junk";
    address = "junk@sumnerevans.com";
    color = "red";
  };

  bookMyTimeAdmin = {
    name = "BMT-Admin";
    address = "admin@bookmyti.me";
    color = "green";
  };

  mineshspcAdmin = {
    name = "MinesHSPC-Admin";
    address = "admin@mineshspc.com";
    color = "green";
  };

  nevarroAdmin = {
    name = "Nevarro-Admin";
    address = "admin@nevarro.space";
    color = "green";
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts = {
    Comments = mkMerge [
      (helper.commonConfig commentsConfig)
      { flavor = "migadu.com"; }
    ];

    Junk = mkMerge [
      (helper.commonConfig junkConfig)
      { flavor = "migadu.com"; }
    ];

    BMT-Admin = mkMerge [
      (helper.commonConfig bookMyTimeAdmin)
      { flavor = "migadu.com"; }
    ];

    MinesHSPC-Admin = mkMerge [
      (helper.commonConfig mineshspcAdmin)
      (helper.imapnotifyConfig mineshspcAdmin)
      { flavor = "migadu.com"; }
    ];

    Nevarro-Admin = mkMerge [
      (helper.commonConfig nevarroAdmin)
      (helper.imapnotifyConfig nevarroAdmin)
      { flavor = "migadu.com"; }
    ];
  };
}
