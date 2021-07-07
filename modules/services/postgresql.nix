{ config, lib, pkgs, ... }: with lib; mkMerge [
  (
    mkIf config.services.postgresql.enable {
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

      services.postgresql.settings = {
        max_connections = 20;
        shared_buffers = "256MB";
        effective_cache_size = "768MB";
        maintenance_work_mem = "64MB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "7864kB";
        default_statistics_target = 100;
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        work_mem = "6553kB";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
      };
    }
  )

  (
    mkIf config.services.postgresqlBackup.enable {
      # Run backup every 3 hours.
      services.postgresqlBackup = {
        backupAll = true;
        startAt = "0/3:0"; # systemd-analyze calendar "0/3:0"
      };

      # Add a backup service.
      services.backup.backups.postgresql = {
        path = config.services.postgresqlBackup.location;
      };
    }
  )
]
