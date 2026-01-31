{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    ./fonts.nix
    ./sway.nix
  ];

  config = mkIf config.programs.sway.enable {
    # Add some Gnome services to make things work.
    programs.dconf.enable = true;
    services.dbus.packages = with pkgs; [
      dconf
      gcr
    ];
    services.gnome.at-spi2-core.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Thumbnailing service
    services.tumbler.enable = true;

    # Use geoclue2 as the location provider for things like redshift/gammastep.
    location.provider = "geoclue2";
    services.geoclue2.appConfig.redshift = {
      isAllowed = true;
      isSystem = true;
    };
  };
}
