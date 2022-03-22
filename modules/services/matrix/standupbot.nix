{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.standupbot;
  standupbot = pkgs.callPackage ../../../pkgs/standupbot { };

  standupbotConfig = {
    Username = cfg.username;
    Homeserver = cfg.homeserver;
    PasswordFile = cfg.passwordFile;
  };
  format = pkgs.formats.json { };
  standupbotConfigJson = format.generate "standupbot.config.json" standupbotConfig;
in
{
  options = {
    services.standupbot = {
      enable = mkEnableOption "standupbot";
      username = mkOption {
        type = types.str;
        default = "@standupbot:${config.networking.domain}";
      };
      homeserver = mkOption {
        type = types.str;
        default = "http://localhost:8008";
      };
      passwordFile = mkOption {
        type = types.path;
        default = "/var/lib/standupbot/passwordfile";
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/standupbot";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.standupbot = {
      description = "Standupbot";
      after = [ "matrix-synapse.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${standupbot}/bin/standupbot --config ${standupbotConfigJson}
        '';
        Restart = "on-failure";
        User = "standupbot";
      };
    };

    users = {
      users.standupbot = {
        group = "standupbot";
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
      groups.standupbot = { };
    };
  };
}
