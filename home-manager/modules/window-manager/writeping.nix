{ config, pkgs, ... }:
let
  rollingPingFile = "${config.home.homeDirectory}/tmp/rolling_ping";
  writepingScript = pkgs.writeShellScript "writeping" ''
    ${pkgs.coreutils}/bin/touch ${rollingPingFile}

    # Append the new ping time.
    ping=$(${pkgs.iputils}/bin/ping -c 1 -W 1 8.8.8.8)
    if [[ $? != 0 ]]; then
        echo "fail" > ${rollingPingFile}
    else
        ${pkgs.coreutils}/bin/cat ${rollingPingFile} | \
          ${pkgs.gnugrep}/bin/grep "fail" && \
          echo -n "" > ${rollingPingFile}
        ping=$(echo $ping | \
          ${pkgs.gnugrep}/bin/grep 'rtt' | \
          ${pkgs.coreutils}/bin/cut -d '/' -f 5)
        echo $ping >> ${rollingPingFile}
    fi

    # Only keep the last 10 values.
    echo "$(${pkgs.coreutils}/bin/tail ${rollingPingFile})" > ${rollingPingFile}
  '';
in
{
  systemd.user.services.writeping = {
    Unit.Description = "Write the new ping value for rolling ping average calculation";

    Service = {
      Type = "oneshot";
      ExecStart = "${writepingScript}";
    };
  };

  systemd.user.timers.writeping = {
    Unit.Description = "Write the new ping value for rolling ping average calculation";

    Timer = {
      OnCalendar = "*:*:0/10"; # Every 10 seconds
      Unit = "writeping.service";
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
