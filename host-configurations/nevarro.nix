{ config, lib, ... }: {
  hardware.isServer = true;

  # Set the hostname
  networking.hostName = "nevarro";
  networking.domain = "nevarro.space";

  networking.interfaces.eth0.useDHCP = true;

  # Enable a lot of swap since we have enough disk. This way, if Airsonic eats
  # memory, it won't crash the box.
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

  # Websites
  services.nginx.websites = [
    { hostname = "nevarro.space"; }
  ];

  # Services
  services.healthcheck.checkId = "0a1a1c13-e65d-4968-a498-c5709dcb2ae8";

  # PR Tracker
  services.pr-tracker = {
    enable = true;
    githubApiTokenFile = "/etc/nixos/secrets/pr-tracker-github-token";
    sourceUrl = "https://git.sr.ht/~sumner/pr-tracker";
  };

  # Synapse
  services.matrix-synapse.enable = true;
  services.matrix-synapse.registration_shared_secret = lib.removeSuffix "\n"
    (builtins.readFile ../secrets/matrix-registration-shared-secret-nevarro);

  services.quotesfilebot.enable = true;
  services.quotesfilebot.passwordFile = "/etc/nixos/secrets/quotesfilebot-password";

  # PosgreSQL
  services.postgresql.dataDir = "/mnt/nevarro-postgresql-data/postgresql/11.1";
  services.postgresqlBackup.enable = true;
}
