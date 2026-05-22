{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  accountConfig = {
    address = "sumner@nevarro.space";
    name = "Nevarro";
    color = "yellow";
    signatureLines = ''
      Sumner Evans
      CEO of Nevarro, LLC

      https://sumnerevans.com | @sumner:nevarro.space
    '';
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts = {
    Nevarro = mkMerge [
      (helper.commonConfig accountConfig)
      (helper.imapnotifyConfig accountConfig)
      (helper.signatureConfig accountConfig)
      helper.gpgConfig
      {
        flavor = "gmail.com";
        folders = {
          drafts = "[Gmail]/Drafts";
          sent = "[Gmail]/Sent Mail";
          trash = "[Gmail]/Trash";
        };
      }
    ];
  };
}
