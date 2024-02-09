{
  imports = [
    ./gui

    ./acme.nix
    ./airsonic.nix
    ./bitwarden.nix
    ./docker.nix
    ./gonic.nix
    ./grafana.nix
    ./healthcheck.nix
    ./isso.nix
    ./journald.nix
    ./mumble.nix
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
  services.postgresql.enable = true;
}
