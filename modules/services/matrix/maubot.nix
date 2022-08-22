{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.maubot;
  maubot = pkgs.callPackage ../../../pkgs/maubot.nix { };

  maubotConfig = {
    database = "postgresql://maubot:maubot@localhost/maubot";
    server = {
      public_url = cfg.public_url;
    };
    homeservers = cfg.homeservers;
    admins = cfg.admins;
    logging = {
      version = 1;
      formatters = {
        normal = {
          format = "[%(asctime)s] [%(levelname)s@%(name)s] %(message)s";
        };
      };
      handlers = {
        console = {
          class = "logging.StreamHandler";
          formatter = "normal";
        };
      };
      loggers = {
        maubot = { level = "DEBUG"; };
        mau = { level = "DEBUG"; };
        aiohttp = { level = "DEBUG"; };
      };
      root = {
        level = "DEBUG";
        handlers = [ "console" ];
      };
    };
  };
  format = pkgs.formats.yaml { };
  configYaml = format.generate "maubot.config.yaml" maubotConfig;
in
{
  options = {
    services.maubot = {
      enable = mkEnableOption "maubot";
      public_url = mkOption {
        type = types.str;
      };
      homeservers = mkOption {
        type = with types; attrsOf attrs;
        default = { };
      };
      admins = mkOption {
        type = with types; attrsOf str;
        default = { };
      };
      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/maubot";
      };
    };
  };

  config = mkIf cfg.enable {
    # Create a database user for maubot
    services.postgresql.ensureDatabases = [ "maubot" ];
    services.postgresql.ensureUsers = [
      {
        name = "maubot";
        ensurePermissions = {
          "DATABASE \"maubot\"" = "ALL PRIVILEGES";
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
    ];

    systemd.services.maubot = {
      description = "Maubot";
      after = [ "matrix-synapse.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = pkgs.writeShellScript "start-maubot.sh" ''
          mkdir -p ${cfg.dataDir}/{plugins,trash,logs}

          pwd
          ${maubot}/bin/maubot \
            --config ${configYaml}
        '';
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        User = "maubot";
        Group = "maubot";
      };
    };

    users = {
      users.maubot = {
        group = "maubot";
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
      };
      groups.maubot = { };
    };
  };
}
