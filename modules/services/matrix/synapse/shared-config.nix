# This is organized to match the sections in
# https://github.com/matrix-org/synapse/blob/develop/docs/sample_config.yaml
{ config, lib, pkgs }: with lib;
let
  cfg = config.services.matrix-synapse-custom;
  yamlFormat = pkgs.formats.yaml { };

  logConfig = {
    version = 1;
    formatters.journal_fmt.format = "%(name)s: [%(request)s] %(message)s";
    filters.context = {
      "()" = "synapse.util.logcontext.LoggingContextFilter";
      request = "";
    };
    handlers.journal = {
      class = "systemd.journal.JournalHandler";
      formatter = "journal_fmt";
      filters = [ "context" ];
      SYSLOG_IDENTIFIER = "synapse";
    };
    root = { level = "INFO"; handlers = [ "journal" ]; };
    loggers = {
      shared_secret_authenticator = { level = "INFO"; handlers = [ "journal" ]; };
    };
    disable_existing_loggers = false;
  };
in
{
  # Modules
  modules =
    if (cfg.sharedSecretAuthFile == null) then [ ] else [
      {
        module = "shared_secret_authenticator.SharedSecretAuthProvider";
        config = {
          shared_secret = removeSuffix "\n" (readFile cfg.sharedSecretAuthFile);
          m_login_password_support_enabled = true;
        };
      }
    ];

  # Server
  server_name = config.networking.domain;
  pid_file = "/run/matrix-synapse.pid";
  default_room_version = "9";
  public_baseurl = "https://matrix.${config.networking.domain}";
  listeners = [
    # CS API and Federation
    {
      type = "http";
      port = 8008;
      bind_address = "0.0.0.0";
      tls = false;
      x_forwarded = true;
      resources = [
        { names = [ "federation" "client" ]; compress = false; }
      ];
    }

    # Metrics
    {
      port = 9009;
      bind_address = "0.0.0.0";
      tls = false;
      type = "metrics";
    }

    # Replication
    {
      type = "http";
      port = 9093;
      bind_address = "127.0.0.1";
      resources = [{ names = [ "replication" ]; }];
    }
  ];

  # Caching
  event_cache_size = "25K";
  caches.global_factor = 1.0;

  # Database
  database = {
    name = "psycopg2";
    args = { user = "matrix-synapse"; database = "matrix-synapse"; };
  };

  # Logging
  log_config = yamlFormat.generate "matrix-synapse-log-config.yaml" logConfig;

  # Media store
  enable_media_repo = false;
  media_store_path = "${cfg.dataDir}/media";
  max_upload_size = "250M";
  url_preview_enabled = true;
  url_preview_ip_range_blacklist = [
    "127.0.0.0/8"
    "10.0.0.0/8"
    "172.16.0.0/12"
    "192.168.0.0/16"
    "100.64.0.0/10"
    "169.254.0.0/16"
    "::1/128"
    "fe80::/64"
    "fc00::/7"
  ];

  media_retention = {
    remote_media_lifetime = "90d";
  };

  url_preview_url_blacklist = [
    # blacklist any URL with a username in its URI
    { username = "*"; }

    # Don't try previews for Linear.
    { netloc = "linear.app"; }
  ];

  # TURN
  # Configure coturn to point at the matrix.org servers.
  # TODO actually figure this out eventually
  turn_uris = [
    "turn:turn.matrix.org?transport=udp"
    "turn:turn.matrix.org?transport=tcp"
  ];
  turn_shared_secret = "n0t4ctuAllymatr1Xd0TorgSshar3d5ecret4obvIousreAsons";
  turn_user_lifetime = "1h";

  # Registration
  enable_registration = false;
  registration_shared_secret = removeSuffix "\n" (readFile cfg.registrationSharedSecretFile);

  # Metrics
  enable_metrics = true;
  report_stats = true;

  # API Configuration
  app_service_config_files = cfg.appServiceConfigFiles;

  # Signing Keys
  signing_key_path = "${cfg.dataDir}/homeserver.signing.key";
  trusted_key_servers = [
    { server_name = "matrix.org"; }
  ];
  suppress_key_server_warning = true;

  # Email
  email = cfg.emailCfg;

  # Workers
  send_federation = false;
  federation_sender_instances = [
    "federation_sender1"
    "federation_sender2"
  ];
  instance_map = {
    event_persister1 = {
      host = "localhost";
      port = 9091;
    };
  };

  stream_writers = {
    events = "event_persister1";
  };

  redis = {
    enabled = true;
  };
}
