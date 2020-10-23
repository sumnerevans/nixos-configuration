{ config, pkgs, ... }: let
  pingCmd = "/run/wrappers/bin/ping";
  pgrepCmd = "${pkgs.procps}/bin/pgrep";
  mbsyncCmd = "${pkgs.isync}/bin/mbsync";
  mailfetchScript = pkgs.writeShellScript "mailfetch" ''
    # Check that the network is up.
    ${pingCmd} -c 1 8.8.8.8
    if [[ "$?" != "0" ]]; then
        echo "Couldn't contact the network. Exiting..."
        exit 1
    fi

    # Chcek to see if we are already syncing.
    pid=$(${pgrepCmd} mbsync)
    if ${pgrepCmd} mbsync &>/dev/null; then
        echo "Process $pid already running. Exiting..." >&2
        exit 1
    fi

    ${mbsyncCmd} -aV 2>&1 | tee ~/tmp/mbsync.log
  '';
in
{
  systemd.user.services.mailfetch = {
    description = "Fetch mail";
    serviceConfig.ExecStart = "${mailfetchScript}";
    path = [ pkgs.pass ];
    startAt = "*:0/5";
  };
}
