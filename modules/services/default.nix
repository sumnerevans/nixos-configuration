{
  imports = [
    ./gui

    ./acme.nix
    ./airsonic.nix
    ./bitwarden.nix
    ./docker.nix
    ./glance.nix
    ./gonic.nix
    ./grafana.nix
    ./healthcheck.nix
    ./isso.nix
    ./journald.nix
    ./nginx.nix
    ./postgresql.nix
    ./restic.nix
    ./sshd.nix
    ./syncthing.nix
    ./webfortune.nix
    ./xandikos.nix
  ];

  # Enable Redis and PostgreSQL
  services.redis.servers."".enable = true;
}
