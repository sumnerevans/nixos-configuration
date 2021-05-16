{ config, pkgs, ... }:
{
  imports = [
    ./matrix
    ./gui

    ./acme.nix
    ./airsonic.nix
    ./autoupgrade.nix
    ./bitwarden.nix
    ./goaccess.nix
    ./healthcheck.nix
    ./isso.nix
    ./logrotate.nix
    ./longview.nix
    ./matrix/default.nix
    ./mumble.nix
    ./nginx.nix
    ./postgresql.nix
    ./restic.nix
    ./sshd.nix
    ./syncthing.nix
    ./thelounge.nix
    ./xandikos.nix
  ];
}
