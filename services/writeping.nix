{ pkgs, ... }: let
  writepingScript = pkgs.writeShellScript "writeping" ''
    ${pkgs.coreutils}/bin/touch ~/tmp/rolling_ping

    # Append the new ping time.
    ping=$(/run/wrappers/bin/ping -c 1 -W 1 8.8.8.8)
    if [[ $? != 0 ]]; then
        echo "fail" > ~/tmp/rolling_ping
    else
        cat ~/tmp/rolling_ping | grep "fail"
        [[ $? == 0 ]] && rm ~/tmp/rolling_ping
        ping=$(echo $ping | \
          ${pkgs.gnugrep}/bin/grep 'rtt' | \
          ${pkgs.coreutils}/bin/cut -d '/' -f 5)
        echo $ping >> ~/tmp/rolling_ping
    fi

    # Only keep the last 10 values.
    echo "$(${pkgs.coreutils}/bin/tail ~/tmp/rolling_ping)" > ~/tmp/rolling_ping
  '';
in
{
  systemd.user.services.writeping = {
    description = "Write a new ping value for rolling ping average calculation";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${writepingScript}";
    };
    startAt = "*:*:0/5";
  };
}
