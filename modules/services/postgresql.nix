{ config, lib, pkgs, ... }: with lib; mkMerge [
  (
    mkIf config.services.postgresql.enable {
      services.postgresql.settings = {
        max_connections = 500;
        shared_buffers = "2GB";
        effective_cache_size = "6GB";
        maintenance_work_mem = "512MB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "16MB";
        default_statistics_target = 100;
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        work_mem = "10485kB";
        min_wal_size = "2GB";
        max_wal_size = "8GB";
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
