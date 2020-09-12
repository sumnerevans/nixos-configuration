{ config, pkgs, ... }: let
  pingCmd = "/run/wrappers/bin/ping";
  pgrepCmd = "${pkgs.procps}/bin/pgrep";
  mbsyncCmd = "${pkgs.isync}/bin/mbsync";
  mailfetchScript = pkgs.writeScriptBin "mailfetch" ''
    #!${pkgs.stdenv.shell}

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

    ${mbsyncCmd} -aV 2>&1 | tee /tmp/mbsync.log
  '';
in
{
  systemd.user.services.mailfetch = {
    description = "Fetch mail";
    serviceConfig.ExecStart = "${mailfetchScript}/bin/mailfetch";
    path = [ pkgs.pass ];
  };

  systemd.user.timers.mailfetch = {
    description = "Fetch mail every 5 minutes";
    timerConfig = {
      OnCalendar = "*:0/5";
    };
  };
}
