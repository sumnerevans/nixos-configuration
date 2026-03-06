{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  offlinemsmtp = pkgs.callPackage ../../pkgs/offlinemsmtp.nix { };
  cfg = config.offlinemsmtp;

  args = [
    "--daemon"
    "--loglevel DEBUG"
    "--file ${config.xdg.configHome}/msmtp/config"
  ]
  # If headless, don't do notifications.
  ++ (optional cfg.headless "--silent")
  # Add sendmail file if it exists
  ++ (optional (cfg.sendmailFile != null) "--send-mail-file ${cfg.sendmailFile}");
in
{
  options = {
    offlinemsmtp = {
      headless = mkEnableOption "headless version of offlinemsmtp that doesn't do any notifications";
      enableSendmailFile = mkEnableOption "a sendmail file";

      sendmailFile = mkOption {
        type = with types; nullOr str;
        description = "The file to gate sending mail using for offlinemsmtp";
        default = "${config.home.homeDirectory}/tmp/offlinemsmtp-sendmail";
      };
    };
  };

  config = {
    systemd.user.services.offlinemsmtp = {
      Unit = {
        Description = "offlinemsmtp daemon";
        PartOf = if cfg.headless then [ "graphical-session.target" ] else [ "default.target" ];
      };

      Service = {
        ExecStart = ''
          ${offlinemsmtp}/bin/offlinemsmtp ${concatStringsSep " " args}
        '';
        Restart = "always";
        RestartSec = 5;
      };

      Install.WantedBy = if cfg.headless then [ "graphical-session.target" ] else [ "default.target" ];
    };
  };
}
