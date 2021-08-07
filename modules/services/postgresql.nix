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
        max_connections = 500;
        shared_buffers = "512MB";
        effective_cache_size = "1536MB";
        maintenance_work_mem = "128MB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "16MB";
        default_statistics_target = 100;
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        work_mem = "1048kB";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
        max_worker_processes = 2;
        max_parallel_workers_per_gather = 1;
        max_parallel_workers = 2;
        max_parallel_maintenance_workers = 1;
      };

      systemd.services.postgresql = {
        serviceConfig = {
          TimeoutSec = mkForce 0;
        };
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
