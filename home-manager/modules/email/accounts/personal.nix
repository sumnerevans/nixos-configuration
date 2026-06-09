{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  oldGmailAccountConfig = {
    address = "sumner.evans98@gmail.com";
    name = "Gmail";
    color = "yellow";
    signatureLines = ''
      Sumner Evans
      Senior Implementation Tech Lead at Can/Am Technologies

      https://sumnerevans.com | @sumner:nevarro.space

      Note, this is not my main email, please update your contact information
      for me to my new email: me@sumnerevans.com.
    '';
  };

  personalAccountConfig = {
    address = "me@sumnerevans.com";
    name = "Personal";
    color = "green";
    signatureLines = ''
      Sumner Evans
      Senior Implementation Tech Lead at Can/Am Technologies

      https://sumnerevans.com | @sumner:nevarro.space
    '';
  };

  helper = import ./account-config-helper.nix { inherit config pkgs lib; };
in
{
  accounts.email.accounts = {
    Personal = mkMerge [
      (helper.commonConfig personalAccountConfig)
      (helper.imapnotifyConfig personalAccountConfig)
      (helper.signatureConfig personalAccountConfig)
      helper.gpgConfig
      {
        flavor = "gmail.com";
        primary = true;
        folders = {
          drafts = "[Gmail]/Drafts";
          sent = "[Gmail]/Sent Mail";
          trash = "[Gmail]/Trash";
        };
      }
    ];

    Gmail = mkMerge [
      (helper.commonConfig oldGmailAccountConfig)
      (helper.imapnotifyConfig oldGmailAccountConfig)
      (helper.signatureConfig oldGmailAccountConfig)
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
