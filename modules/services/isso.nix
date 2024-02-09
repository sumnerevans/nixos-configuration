{ config, lib, ... }:
with lib;
let issoCfg = config.services.isso;
in {
  config = mkIf issoCfg.enable {
    services.isso.settings = {
      general = {
        host = "https://sumnerevans.com";
        notify = "smtp";
        reply-notifications = true;
        gravatar = true;
      };
      moderation = {
        enabled = true;
        purge-after = "30d";
      };
      server = { listen = "http://127.0.0.1:8888/"; };
      smtp = {
        username = "comments@sumnerevans.com";
        password = lib.removeSuffix "\n"
          (builtins.readFile ../../secrets/isso-comments-smtp-password);
        host = "smtp.migadu.com";
        port = 587;
        security = "starttls";
        to = "admin@sumnerevans.com";
        from = "comments@sumnerevans.com";
      };
      guard = {
        enabled = true;
        ratelimit = 2;
        direct-reply = 3;
        reply-to-self = false;
      };
      markup = {
        options =
          "tables, fenced-code, footnotes, autolink, strikethrough, underline, math, math-explicit";
        allowed-elements = "img";
        allowed-attributes = "src";
      };
      admin = {
        enabled = true;
        password = lib.removeSuffix "\n"
          (builtins.readFile ../../secrets/isso-admin-password);
      };
    };

    # Set up nginx to forward requests properly.
    services.nginx.virtualHosts = {
      "comments.sumnerevans.com" = {
        enableACME = true;
        forceSSL = true;

        locations."/".proxyPass = "http://127.0.0.1:8888";
      };
    };

    # Add a backup service.
    services.backup.backups.isso.path = "/var/lib/private/isso";
  };
}
