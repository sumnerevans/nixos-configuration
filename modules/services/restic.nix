# This is similar to
# https://github.com/NixOS/nixpkgs/blob/release-19.09/nixos/modules/services/backup/restic.nix
# But this module is a bit more specific to my use case. This is what it does:
# 1. It exposes a very simple interface to the other modules where they can
#    just specify a directory that needs to be backed up.
# 2. Each folder that's backed up by this service is backed up to B2.
# 3. After each backup, I check it's validity.
# 4. I forget old snapshots and prune every day.
# 5. It creates a new service for each of the configured backup paths that is
#    run at startup. If a special `.restic-backup-restored` file does not exist
#    in that directory, it will restore all data from B2 to that directory.
#    This service can be set as a prerequisite for starting up other services
#    that depend on that data.

{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.backup;
  bucket = "test-scarif-backup";
  repoPath = config.networking.hostName;
  frequency = "0/6:0"; # Run backup every six hours
  pruneFrequency = "Sun *-*-* 02:00"; # Run prune every Sunday at 02:00
  resticPasswordFile = "/etc/nixos/secrets/restic-password";
  resticEnvironmentFile = "/etc/nixos/secrets/restic-environment-variables";
  resticRepository = "b2:${bucket}:${repoPath}";
  # TODO be able to restore from a different repo path

  resticCmd = "${pkgs.restic}/bin/restic --verbose=3";

  resticEnvironment = {
    RESTIC_PASSWORD_FILE = resticPasswordFile;
    RESTIC_REPOSITORY = resticRepository;
    RESTIC_CACHE_DIR = "/var/cache";
  };

  # Scripts
  # ===========================================================================
  resticBackupScript = paths: exclude: pkgs.writeScriptBin "restic-backup" ''
    #!${pkgs.stdenv.shell}
    set -xe

    ${pkgs.curl}/bin/curl -fsS --retry 10 https://hc-ping.com/${cfg.healthcheckId}/start

    # Perfrom the backup
    ${resticCmd} backup \
      ${concatStringsSep " " paths} \
      ${concatMapStringsSep " " (e: "-e \"${e}\"") exclude}

    # Make sure that the backup has time to settle before running the check.
    sleep 10

    # Check the validity of the repository.
    ${resticCmd} check

    # Ping healthcheck.io
    ${pkgs.curl}/bin/curl -fsS --retry 10 https://hc-ping.com/${cfg.healthcheckId}
  '';

  resticPruneScript = pkgs.writeScriptBin "restic-prune" ''
    #!${pkgs.stdenv.shell}
    set -xe

    ${pkgs.curl}/bin/curl -fsS --retry 10 https://hc-ping.com/${cfg.healthcheckPruneId}/start

    # Remove old backup sets. Keep hourly backups from the past week, daily
    # backups for the past 90 days, weekly backups for the last half year,
    # monthly backups for the last two years, and yearly backups for the last
    # two decades.
    ${resticCmd} forget \
      --prune \
      --group-by host \
      --keep-hourly 168 \
      --keep-daily 90 \
      --keep-weekly 26 \
      --keep-monthly 24 \
      --keep-yearly 20

    # Ping healthcheck.io
    ${pkgs.curl}/bin/curl -fsS --retry 10 https://hc-ping.com/${cfg.healthcheckPruneId}
  '';

  resticRestoreScript = path: pkgs.writeScriptBin "restic-restore" ''
    #!${pkgs.stdenv.shell}
    set -xe

    # If the backup has already been restored, print an error and exit.
    [[ -f ${path}/.restic-backup-restored ]] &&
      echo "A backup has already been restored for ${path}." &&
      echo "Remove ${path}/.restic-backup-restored if you want to force a restore." &&
      exit 1

    # Perfrom the restoration.
    ${resticCmd} restore latest --verify --target / -i ${path}

    # Create the .restic-backup-restored file to indicate that this backup has
    # been restored.
    touch ${path}/.restic-backup-restored
  '';

  # Services
  # ===========================================================================
  resticBackupService = backups: exclude:
    let
      paths = mapAttrsToList (n: { path, ... }: path) backups;
      script = resticBackupScript paths (exclude ++ [ ".restic-backup-restored" ]);
    in
    {
      name = "restic-backup";
      value = {
        description = "Backup ${concatStringsSep ", " paths} to ${resticRepository}";
        environment = resticEnvironment;
        startAt = frequency;
        serviceConfig = {
          ExecStart = "${script}/bin/restic-backup";
          EnvironmentFile = resticEnvironmentFile;
          PrivateTmp = true;
          ProtectSystem = true;
          ProtectHome = "read-only";
        };
        # Initialize the repository if it doesn't exist already.
        preStart = ''
          ${resticCmd} snapshots || ${resticCmd} init
        '';
      };
    };

  resticPruneService = {
    name = "restic-prune";
    value = {
      description = "Prune ${resticRepository}";
      environment = resticEnvironment;
      startAt = pruneFrequency;
      serviceConfig = {
        ExecStart = "${resticPruneScript}/bin/restic-prune";
        EnvironmentFile = resticEnvironmentFile;
        PrivateTmp = true;
        ProtectSystem = true;
        ProtectHome = "read-only";
      };
      # Initialize the repository if it doesn't exist already.
      preStart = ''
        ${resticCmd} snapshots || ${resticCmd} init
      '';
    };
  };

  resticRestoreService = name: { path, serviceName, ... }:
    let
      script = resticRestoreScript path;
    in
    {
      name = serviceName;
      value = {
        description = "Restore ${path} from the latest restic backup.";
        environment = resticEnvironment;
        serviceConfig = {
          ExecStart = "${script}/bin/restic-restore";
          EnvironmentFile = resticEnvironmentFile;
        };
      };
    };
in
{
  options =
    let
      backupDirOpts = { name, ... }: {
        options = {
          path = mkOption {
            type = types.str;
            description = "The path to backup using restic.";
          };
          serviceName = mkOption {
            type = types.str;
            default = "restic-restore-${name}";
            description = "The name of the restore service to create.";
          };
        };
      };
    in
    {
      services.backup = {
        backups = mkOption {
          type = with types; attrsOf (submodule backupDirOpts);
          description = "List of backup configurations.";
          default = { };
        };

        exclude = mkOption {
          type = with types; listOf str;
          description = ''
            List of patterns to exclude. `.restic-backup-restored` files are
            already ignored.
          '';
          default = [ ];
          example = [ ".git/*" ];
        };

        healthcheckId = mkOption {
          type = types.str;
          description = ''
            Healthcheck ID for this server's backup job.
          '';
        };

        healthcheckPruneId = mkOption {
          type = types.str;
          description = ''
            Healthcheck ID for this server's prune job.
          '';
        };
      };
    };

  config = mkIf (cfg.backups != { }) {
    systemd.services =
      let
        resticServices = [
          # The main backup service.
          (resticBackupService cfg.backups cfg.exclude)

          # The main prune service.
          resticPruneService
        ]

        # The restore services.
        ++ mapAttrsToList resticRestoreService cfg.backups;
      in
      listToAttrs resticServices;
  };
}
