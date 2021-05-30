{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.quotesfilebot;
  quotesfilebot = pkgs.callPackage ../../../pkgs/quotesfilebot {};

  quotesfilebotConfig = {
    DefaultReactionEmoji = cfg.defaultReactionEmoji;
    Username = cfg.username;
    Homeserver = cfg.homeserver;
    PasswordFile = cfg.passwordFile;
    JoinMessage = cfg.joinMessage;
  };
  format = pkgs.formats.json {};
  quotesfilebotConfigJson = format.generate "quotesfilebot.json" quotesfilebotConfig;
in
{
  options = {
    services.quotesfilebot = {
      enable = mkEnableOption "quotesfilebot";
      defaultReactionEmoji = mkOption {
        type = types.str;
        default = "💬";
      };
      username = mkOption {
        type = types.str;
        default = "@quotesfilebot:${config.networking.domain}";
      };
      homeserver = mkOption {
        type = types.str;
        default = "http://localhost:8008";
      };
      passwordFile = mkOption {
        type = types.path;
        default = "/var/lib/quotesfilebot/passwordfile";
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/quotesfilebot";
      };
      joinMessage = mkOption {
        type = types.str;
        default = "I'm a quotesfilebot!";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.quotesfilebot = {
      description = "Quotesfilebot";
      after = [ "matrix-synapse.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${quotesfilebot}/bin/quotes-file-bot --config ${quotesfilebotConfigJson}
        '';
        Restart = "on-failure";
        User = "quotesfilebot";
      };
    };

    users = {
      users.quotesfilebot = {
        group = "quotesfilebot";
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
      groups.quotesfilebot = {};
    };
  };
}
