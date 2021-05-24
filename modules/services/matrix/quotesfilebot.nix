{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.quotesfilebot;
  quotesfilebot = pkgs.callPackage ../../../pkgs/quotesfilebot { };

  quotesfilebotConfig = {
    DefaultReactionEmoji = cfg.defaultReactionEmoji;
    Username = cfg.username;
    Homeserver = cfg.homeserver;
    AccessToken = cfg.accessToken;
    JoinMessage = cfg.joinMessage;
  };
  quotesfilebotConfigJson = pkgs.writeText "quotesfilebot.json" (
    generators.toJSON { } quotesfilebotConfig);
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
      accessToken = mkOption {
        type = types.str;
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
      };
    };
  };
}
