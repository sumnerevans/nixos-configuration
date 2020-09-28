{ lib, ... }:
{
  config = {
    location.provider = "geoclue2";
    services.redshift = {
      enable = true;

      brightness = {
        day = "1";
        night = "0.9";
      };

      temperature = {
        day = 5500;
        night = 4000;
      };
    };

    systemd.user.services.redshift = {...}: {
      options = {
        serviceConfig = lib.mkOption {
          apply = opts: opts // {
            ExecStart = builtins.replaceStrings [ "/bin/redshift" ] [ "/bin/redshift-gtk" ] opts.ExecStart;
          };
        };
      };
      config = {};
    };
  };
}
