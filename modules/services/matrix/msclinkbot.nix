{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.msclinkbot;
  msclinkbot = pkgs.callPackage ../../../pkgs/msclinkbot.nix { };

  mscLinkBotConfig = {
    username = cfg.username;
    uomeserver = cfg.homeserver;
    password_file = cfg.passwordFile;

    database = {
      type = "sqlite3";
      uri = "${cfg.databaseDir}/msclinkbot.db";
    };

    logging = {
      min_level = "debug";
      writers = [
        { type = "stdout"; format = "json"; }
      ];
    };
  };
  format = pkgs.formats.yaml { };
  mscLinkBotConfigFile = format.generate "msclinkbot.config.yaml" mscLinkBotConfig;
in
{
  options = {
    services.msclinkbot = {
      enable = mkEnableOption "MSC Link Bot";
      username = mkOption {
        type = types.str;
        default = "@mscbot:${config.networking.domain}";
      };
      homeserver = mkOption {
        type = types.str;
        default = "http://localhost:8008";
      };
      passwordFile = mkOption {
        type = types.path;
        default = "/var/lib/msclinkbot/passwordfile";
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/msclinkbot";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.msclinkbot = {
      description = "MSC Link Bot";
      after = [ "matrix-synapse.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${msclinkbot}/bin/msclinkbot --config ${mscLinkBotConfigFile}
        '';
        Restart = "on-failure";
        User = "msclinkbot";
      };
    };

    users = {
      users.msclinkbot = {
        group = "msclinkbot";
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
      groups.msclinkbot = { };
    };
  };
}
