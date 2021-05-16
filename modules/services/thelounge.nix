{ config, lib, ... }:
let
  loungeHome = "/var/lib/thelounge";
  serverName = "irc.${config.networking.domain}";
  theloungeCfg = config.services.thelounge;
in
lib.mkIf theloungeCfg.enable {
  services.thelounge = {
    private = true;
    extraConfig = {
      reverseProxy = true;
      theme = "morning";
      defaults = {
        name = "Freenode";
        host = "chat.freenode.net";
        port = 6697;
        tls = true;
      };
    };
  };

  users.users.thelounge = {
    useDefaultShell = true;
    home = loungeHome;
  };

  # Set up nginx to forward requests properly.
  services.nginx.virtualHosts = {
    "${serverName}" = {
      enableACME = true;
      forceSSL = true;

      locations."/".proxyPass = "http://127.0.0.1:9000";
    };
  };

  # Add a backup service.
  services.backup.backups.lounge = {
    path = loungeHome;
  };
}
