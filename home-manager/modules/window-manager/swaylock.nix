{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.wayland.windowManager.sway.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        daemonize = true;
        screenshots = true;
        color = "000000";
        clock = true;
        ignoreEmptyPassword = true;
        indicator = true;
        indicatorRadius = 100;
        indicatorThickness = 7;
        effectBlur = "7x5";
        effectVignette = "0.7:0.7";
      };
    };

    # Lock screen & screen off
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "swaylock";
        }
      ];
      events = {
        "before-sleep" = "${pkgs.playerctl}/bin/playerctl pause & swaylock";
      };
    };
  };
}
