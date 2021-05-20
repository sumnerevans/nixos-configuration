{ config, lib, pkgs, ... }: with lib; mkMerge [
  (mkIf config.services.postgresql.enable {
    systemd.services.mkPostgresDataDir = {
      description = "Make sure the postgres data directory exists before booting the service.";
      wantedBy = [ "multi-user.target" ];
      before = [ "postgresql.service" ];
      serviceConfig = {
        ExecStart = pkgs.writeShellScript "ensure-dirs" ''
          mkdir -p ${config.services.postgresql.dataDir}
          chown -R postgres:postgres ${config.services.postgresql.dataDir}
        '';
      };
    };
  })

  (mkIf config.services.postgresqlBackup.enable {
    # Run backup every 3 hours.
    services.postgresqlBackup = {
      backupAll = true;
      startAt = "0/3:0"; # systemd-analyze calendar "0/3:0"
    };

    # Add a backup service.
    services.backup.backups.postgresql = {
      path = config.services.postgresqlBackup.location;
    };
  })
]
