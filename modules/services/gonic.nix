{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.services.gonic2;
in
{
  # TODO convert this to just use the upstream Gonic module
  options.services.gonic2 = {
    enable = mkEnableOption "gonic, a Subsonic compatible music streaming server";
    home = mkOption {
      type = types.path;
      description = "The root directory for Gonic data.";
      default = "/var/lib/gonic";
    };
    virtualHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
      '';
    };
    musicDir = mkOption {
      type = types.path;
      description = "The path to the music directory";
      default = "/var/lib/gonic/music";
    };
    podcastPath = mkOption {
      type = types.path;
      description = "The path to the podcast directory";
      default = "/var/lib/gonic/podcasts";
    };
    cachePath = mkOption {
      type = types.path;
      description = "The path to the cache directory";
      default = "/var/lib/gonic/cache";
    };
    dbPath = mkOption {
      type = types.path;
      description = "The path to the Gonic database file.";
      default = "/var/lib/gonic/gonic.db";
    };
    listenAddress = mkOption {
      type = types.str;
      description = "The host and port to listen on";
      default = "0.0.0.0:4747";
    };
    proxyPrefix = mkOption {
      type = types.str;
      description = "url path prefix to use if behind reverse proxy";
      default = "/";
    };
    scanInterval = mkOption {
      type = types.nullOr types.int;
      description = "interval (in minutes) to check for new music (automatic scanning disabled if null)";
      default = null;
    };
    jukeboxEnabled = mkOption {
      type = types.bool;
      description = "whether the subsonic jukebox api should be enabled";
      default = false;
    };
    genreSplit = mkOption {
      type = types.nullOr types.str;
      description = "a string or character to split genre tags on for multi-genre support";
      default = null;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.gonic = {
      description = "Gonic service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        GONIC_MUSIC_PATH = cfg.musicDir;
        GONIC_PODCAST_PATH = cfg.podcastPath;
        GONIC_CACHE_PATH = cfg.cachePath;
        GONIC_DB_PATH = cfg.dbPath;
        GONIC_LISTEN_ADDR = cfg.listenAddress;
        GONIC_PROXY_PREFIX = cfg.proxyPrefix;
        GONIC_SCAN_INTERVAL = toString cfg.scanInterval;
        GONIC_JUKEBOX_ENABLED = toString cfg.jukeboxEnabled;
        GONIC_GENRE_SPLIT = cfg.genreSplit;
      };
      preStart = ''
        mkdir -p ${cfg.musicDir}
        mkdir -p ${cfg.podcastPath}
        mkdir -p ${cfg.cachePath}
      '';
      serviceConfig = {
        ExecStart = "${pkgs.gonic}/bin/gonic";
        TimeoutSec = 10;
        Restart = "always";
        User = "gonic";
        Group = "music";
      };
    };

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts.${cfg.virtualHost} = {
        locations.${cfg.proxyPrefix}.proxyPass = "http://${cfg.listenAddress}";
      };
    };

    users.users.gonic = {
      description = "Gonic service user";
      group = "music";
      name = "gonic";
      home = cfg.home;
      createHome = true;
      isSystemUser = true;
    };
    users.groups.music = { };
  };
}
