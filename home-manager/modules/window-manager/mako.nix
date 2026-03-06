{ config, lib, ... }:
{
  config = lib.mkIf config.wayland.windowManager.sway.enable {
    services.mako = {
      enable = true;

      settings = {
        border-radius = "5";
        border-size = "2";
        default-timeout = "8000";
        font = "Iosevka 12";
        group-by = "app-name,summary";
        sort = "-priority";
        width = "400";
        background-color = "#191311";
        border-color = "#5B8234";
        text-color = "#5B8234";

        "urgency=critical" = {
          border-color = "#B7472A";
          text-color = "#B7472A";
          background-color = "#191311";
          default-timeout = "60000";
        };

        "urgency=low" = {
          border-color = "#777777";
          text-color = "#777777";
          background-color = "#191311";
        };
      };
    };
  };
}
