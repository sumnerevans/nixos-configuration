{ config, pkgs, ... }:
{
  imports = [
    ./matrix
    ./gui

    ./acme.nix
    ./airsonic.nix
    ./autoupgrade.nix
    ./bitwarden.nix
    ./docker.nix
    ./goaccess.nix
    ./grafana.nix
    ./healthcheck.nix
    ./isso.nix
    ./logrotate.nix
    ./longview.nix
    ./matrix/default.nix
    ./mumble.nix
    ./nginx.nix
    ./postgresql.nix
    ./pr-tracker.nix
    ./restic.nix
    ./sshd.nix
    ./syncthing.nix
    ./xandikos.nix
  ];
}
