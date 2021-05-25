{ config, lib, pkgs, ... }: with pkgs; with lib; let
  synapseCfg = config.services.matrix-synapse;
  adminAccessToken = "";

  port = toString (elemAt synapseCfg.listeners 0).port;

  deleteForgottenRoomsScript = writeShellScriptBin "delete-forgotten-rooms" ''
    ${curl}/bin/curl \
        --header "Authorization: Bearer ${adminAccessToken}" \
        'http://localhost:${port}/_synapse/admin/v1/rooms?limit=1000&order_by=joined_local_members&dir=b' |
      ${jq}/bin/jq \
        '.rooms[] | select(.joined_local_members == 0)'
  '';
in
{
  environment.systemPackages = [ deleteForgottenRoomsScript ];
}
