{ config, pkgs, lib, ... }:
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

  # Use redshift-gtk instead of redshift.
  # nixpkgs.overlays = [
  #   (self: super: {
  #     picom = super.systemd.user.services.overrideAttrs (old: let
  #       cfg = old.cfg;
  #       lcfg = old.lcfg;
  #       providerString = old.providerString;
  #     in {
  #       ExecStart = ''
  #         ${cfg.package}/bin/redshift-gtk \
  #           -l ${providerString} \
  #           -t ${toString cfg.temperature.day}:${toString cfg.temperature.night} \
  #           -b ${toString cfg.brightness.day}:${toString cfg.brightness.night} \
  #           ${lib.strings.concatStringsSep " " cfg.extraOptions}
  #       '';
  #     });
  #   })
  # ];

  # systemd.user.services.redshift.serviceConfig = let
  #   cfg = config.services.redshift;
  #   lcfg = config.location;
  #   providerString = if lcfg.provider == "manual"
  #     then "${toString lcfg.latitude}:${toString lcfg.longitude}"
  #     else lcfg.provider;
  # in {
  #   ExecStart = ''
  #     ${cfg.package}/bin/redshift-gtk \
  #       -l ${providerString} \
  #       -t ${toString cfg.temperature.day}:${toString cfg.temperature.night} \
  #       -b ${toString cfg.brightness.day}:${toString cfg.brightness.night} \
  #       ${lib.strings.concatStringsSep " " cfg.extraOptions}
  #   '';
  # };
}
