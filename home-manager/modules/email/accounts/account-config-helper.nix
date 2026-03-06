{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  offlinemsmtp = pkgs.callPackage ../../../pkgs/offlinemsmtp.nix { };

  # Create a signature script that gets a quote.
  mkSignatureScript =
    signatureLines:
    pkgs.writeScript "signature" ''
      #!${pkgs.python3}/bin/python
      import subprocess

      ${concatMapStringsSep "\n" (l: ''print("${l}")'') (splitString "\n" signatureLines)}

      # Quote
      quotes_cmd = ["${pkgs.fortune}/bin/fortune", "${config.xdg.dataHome}/fortune/quotes"]
      quote = ""
      # Not sure why, but sometimes fortune returns an empty fortune.
      while len(quote) == 0:
          quote = subprocess.check_output(quotes_cmd).decode("utf-8").strip()
      print(quote)
    '';
in
{
  # Common configuration
  commonConfig =
    {
      address,
      name,
      color ? "",
      ...
    }:
    {
      inherit address;

      realName = mkDefault "Sumner Evans";
      userName = mkDefault address;
      passwordCommand = mkDefault "${pkgs.coreutils}/bin/cat ${config.xdg.configHome}/home-manager/secrets/mail/${address}";

      mbsync = {
        enable = true;
        create = "both";
        remove = "both";
        expunge = "both";
      };

      msmtp.enable = true;

      neomutt = {
        enable = true;
        sendMailCommand = "${offlinemsmtp}/bin/offlinemsmtp -a ${name}";

        extraConfig = concatStringsSep "\n" (
          [
            ''set folder="${config.accounts.email.maildirBasePath}"''
            ''set pgp_default_key = "B50022FD"''
          ]
          ++ (optional (color != "") "color status ${color} default")
        );
      };

      folders.inbox = "INBOX";
    };

  gpgConfig.gpg = {
    encryptByDefault = true;
    key = "3F15C22BFD125095F9C072758904527AB50022FD";
    signByDefault = true;
  };

  imapnotifyConfig =
    { name, ... }:
    {
      imapnotify = {
        enable = true;
        boxes = [ "INBOX" ];
        onNotify = "${pkgs.isync}/bin/mbsync ${name}:%s";
      };
    };

  signatureConfig =
    { signatureLines, ... }:
    {
      signature = {
        showSignature = "append";
        command = mkSignatureScript signatureLines;
      };
    };
}
