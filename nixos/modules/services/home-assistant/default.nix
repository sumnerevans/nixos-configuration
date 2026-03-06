{ config, lib, ... }:
{
  config = lib.mkIf config.services.home-assistant.enable {
    services.home-assistant = {
      extraComponents = [
        # Components required to complete the onboarding
        "analytics"
        "google_translate"
        "met"
        "radio_browser"
        "shopping_list"
        "isal"
      ];
      configWritable = true;
      config = {
        default_config = { };
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
        };
        "map" = { };
        backup = { };
        mobile_app = { };
      };
    };

    networking.firewall.allowedTCPPorts = [ config.services.home-assistant.config.http.server_port ];
  };
}
