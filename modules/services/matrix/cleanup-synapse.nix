# See:
# - https://levans.fr/shrink-synapse-database.html
# - https://foss-notes.blog.nomagic.uk/2021/03/matrix-database-house-cleaning/
{ config, lib, pkgs, ... }:
with pkgs;
with lib;
let
  cfg = config.services.cleanup-synapse;
  synapseCfg = config.services.matrix-synapse;

  adminUrl = "http://localhost:8008/_synapse/admin/v1";
  adminCurl = ''${curl}/bin/curl --header "Authorization: Bearer $CLEANUP_ACCESS_TOKEN" '';

  # Get rid of any rooms that aren't joined by anyone from the homeserver.
  cleanupForgottenRooms = writeShellScriptBin "cleanup-forgotten" ''
    set -xe

    roomlist=$(mktemp)
    to_purge=$(mktemp)

    ${adminCurl} '${adminUrl}/rooms?limit=1000' > $roomlist

    # Find all of the rooms that have no local users.
    ${jq}/bin/jq -r '.rooms[] | select(.joined_local_members == 0) | .room_id' < $roomlist > $to_purge

    while read room_id; do 
      echo "deleting $room_id..."
      ${adminCurl} \
        -X DELETE \
        -H "Content-Type: application/json" \
        -d "{}" \
        "${adminUrl}/rooms/$room_id"
    done < $to_purge
  '';

  # # Delete all non-local room history that is from before 90 days ago.
  # cleanupHistory = writeShellScriptBin "cleanup-history" ''
  #   set -xe
  #   roomlist=$(mktemp)

  #   ${adminCurl} '${adminUrl}/rooms?limit=1000' |
  #     ${jq}/bin/jq -r '.rooms[] | .room_id' > $roomlist

  #   now=$(${coreutils}/bin/date +%s%N | ${coreutils}/bin/cut -b1-13)
  #   nintey_days_ago=$(( now - 7776000000 ))

  #   while read room_id; do 
  #     echo "purging history for $room_id..."

  #     ${adminCurl} -X POST -H "Content-Type: application/json" \
  #       -d "{ \"delete_local_events\": false, \"purge_up_to_ts\": $nintey_days_ago }" \
  #       "${adminUrl}/purge_history/$room_id"
  #   done < $roomlist
  # '';

  largeStateRoomsQuery = "SELECT room_id FROM state_groups_state GROUP BY room_id HAVING count(*) > 100000";
  compressState = writeShellScriptBin "compress-state" ''
    set -xe
    bigrooms=$(mktemp)
    echo "\\copy (${largeStateRoomsQuery}) to '$bigrooms' with CSV" |
      ${postgresql}/bin/psql -d matrix-synapse

    while read room_id; do
      echo "compressing state for $room_id"

      state_compressor=$(mktemp)

      ${matrix-synapse-tools.rust-synapse-compress-state}/bin/synapse-compress-state \
        -t \
        -o $state_compressor \
        -p "host=localhost user=matrix-synapse password=synapse dbname=matrix-synapse" \
        -r $room_id

      ${postgresql}/bin/psql -d matrix-synapse < $state_compressor

      rm $state_compressor
    done <$bigrooms

    rm $bigrooms
  '';

  reindexAndVaccum = writeShellScriptBin "reindex-and-vaccum" ''
    set -xe
    systemctl stop matrix-synapse.service

    echo 'REINDEX (VERBOSE) DATABASE "matrix-synapse"' |
      /run/wrappers/bin/sudo -u postgres ${postgresql}/bin/psql -d matrix-synapse

    echo "VACUUM FULL VERBOSE" |
      /run/wrappers/bin/sudo -u postgres ${postgresql}/bin/psql -d matrix-synapse

    systemctl start matrix-synapse.service
  '';

  cleanupSynapseScript = writeShellScriptBin "cleanup-synapse" ''
    set -xe
    ${cleanupForgottenRooms}/bin/cleanup-forgotten
    ${compressState}/bin/compress-state
    ${reindexAndVaccum}/bin/reindex-and-vaccum
  '';
in
{
  options.services.cleanup-synapse = {
    environmentFile = mkOption {
      type = types.path;
      description = "The environment file for the synapse cleanup script.";
    };
  };

  config = mkIf synapseCfg.enable {
    systemd.services.cleanup-synapse = {
      description = "Cleanup synapse";
      startAt = "*-10"; # Cleanup everything on the 10th of each month.
      serviceConfig = {
        ExecStart = "${cleanupSynapseScript}/bin/cleanup-synapse";
        EnvironmentFile = cfg.environmentFile;
        PrivateTmp = true;
        ProtectSystem = true;
        ProtectHome = "read-only";
      };
    };

    # Allow root to manage matrix-synapse database.
    services.postgresql.ensureUsers = [
      {
        name = "root";
        ensurePermissions = {
          "DATABASE \"matrix-synapse\"" = "ALL PRIVILEGES";
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
    ];
  };
}
