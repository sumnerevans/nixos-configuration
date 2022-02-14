{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.matrix-vacation-responder;
  matrix-vacation-responder = pkgs.callPackage ../../../pkgs/matrix-vacation-responder { };

  vacationResponderConfig = {
    homeserver = cfg.homeserver;
    username = cfg.username;
    password_file = cfg.passwordFile;

    vacation_message = ''
      This is no longer my primary Matrix account.
      Please send your messages to [@sumner:nevarro.space](https://matrix.to/#/@sumner:nevarro.space)
    '';
    vacation_message_min_interval = 1440;
    respond_to_groups = true;
  };
  format = pkgs.formats.yaml { };
  matrixVacationResponderConfigYaml = format.generate "matrix-vacation-responder.config.yaml" vacationResponderConfig;
in
{
  options = {
    services.matrix-vacation-responder = {
      enable = mkEnableOption "matrix-vacation-responder";
      username = mkOption {
        type = types.str;
      };
      homeserver = mkOption {
        type = types.str;
        default = "http://localhost:8008";
      };
      passwordFile = mkOption {
        type = types.path;
        default = "/etc/nixos/secrets/matrix/bots/vacation-responder-password";
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/matrixvacationresponder";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.matrix-vacation-responder = {
      description = "Matrix Vacation Responder";
      after = [ "matrix-synapse.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${matrix-vacation-responder}/bin/matrix-vacation-responder \
            --config ${matrixVacationResponderConfigYaml} \
            --dbfile ${cfg.dataDir}/matrix-vacation-responder.db
        '';
        Restart = "on-failure";
        User = "matrixvacationresponder";
      };
    };

    users = {
      users.matrixvacationresponder = {
        group = "matrixvacationresponder";
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
      groups.matrixvacationresponder = { };
    };
  };
}
