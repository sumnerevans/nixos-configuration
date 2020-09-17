{ config, pkgs, ... }:
{
  # TODO switch to redshift-gtk
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
}
