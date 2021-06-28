# See:
# - https://levans.fr/shrink-synapse-database.html
# - https://foss-notes.blog.nomagic.uk/2021/03/matrix-database-house-cleaning/
{ config, lib, pkgs, ... }:
with pkgs;
with lib;
let
  synapseCfg = config.services.matrix-synapse;
  prodSynapse = synapseCfg.isProd;
  cleanupEnvironmentFile = "/etc/nixos/secrets/cleanup-synapse-environment";

  adminUrl = "http://localhost:8008/_synapse/admin/v1";
  adminCurl = ''${curl}/bin/curl --header "Authorization: Bearer $CLEANUP_ACCESS_TOKEN" '';

  # Get rid of any rooms that aren't joined by anyone from the homeserver.
  cleanupForgottenRooms = writeScriptBin "cleanup-forgotten" ''
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

  # Delete all non-local room history that is from before 90 days ago.
  cleanupHistory = writeScriptBin "cleanup-history" ''
    set -xe
    roomlist=$(mktemp)

    ${adminCurl} '${adminUrl}/rooms?limit=1000' |
      ${jq}/bin/jq -r '.rooms[] | .room_id' > $roomlist

    now=$(${coreutils}/bin/date +%s%N | ${coreutils}/bin/cut -b1-13)
    nintey_days_ago=$(( now - 7776000000 ))

    while read room_id; do 
      echo "purging history for $room_id..."

      echo ${adminCurl} -X POST -H "Content-Type: application/json" \
        -d "{ \"delete_local_events\": false, \"purge_up_to_ts\": $nintey_days_ago }" \
        "https://matrix.my.home/_synapse/admin/v1/purge_history/$room_id"
    done < $roomlist
  '';

  largeStateRoomsQuery = "SELECT room_id FROM state_groups_state GROUP BY room_id HAVING count(*) > 100000";
  compressState = writeScriptBin "compress-state" ''
    set -xe
    bigrooms=$(mktemp)
    echo "\\copy (${largeStateRoomsQuery}) to '$bigrooms' with CSV"
    echo "\\copy (${largeStateRoomsQuery}) to '$bigrooms' with CSV" | ${postgresql}/bin/psql -d matrix-synapse

    while read room_id; do
      echo "compressing state for $room_id"
    done

    # ${matrix-synapse-tools.rust-synapse-compress-state}
  '';

  reindexAndVaccum = writeScriptBin "reindex-and-vaccum" ''
    set -xe
    systemctl stop matrix-synapse.service

    echo "reindex"
    echo "vaccum"

    systemctl start matrix-synapse.service
  '';

  cleanupSynapseScript = writeScriptBin "cleanup-synapse" ''
    set -xe
    ${cleanupForgottenRooms}/bin/cleanup-forgotten
    ${cleanupHistory}/bin/cleanup-history
    ${compressState}/bin/compress-state
    ${reindexAndVaccum}/bin/reindex-and-vaccum
  '';
in
mkIf (synapseCfg.enable && prodSynapse) {
  systemd.services.cleanup-synapse = {
    description = "Cleanup synapse";
    startAt = "*-10"; # Cleanup everything on the 10th of each month.
    serviceConfig = {
      ExecStart = "${cleanupSynapseScript}/bin/cleanup-synapse";
      EnvironmentFile = cleanupEnvironmentFile;
      PrivateTmp = true;
      ProtectSystem = true;
      ProtectHome = "read-only";
    };
  };
}
