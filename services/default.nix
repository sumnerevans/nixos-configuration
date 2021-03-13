{ config, pkgs, ... }:
{
  imports = [
    ./window-manager/default.nix
  ];

  # Suspend on power button press instead of shutdown.
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  # Enable Flatpak.
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Add some Gnome services to make things work.
  services.dbus.packages = with pkgs; [ gnome3.dconf gcr ];
  services.gnome3.at-spi2-core.enable = true;
  services.gnome3.gnome-keyring.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 32 ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Thumbnailing service
  services.tumbler.enable = true;

  # Enable Redis and PostgreSQL
  services.redis.enable = true;
  services.postgresql.enable = true;

  # Use geoclue2 as the location provider for things like redshift/gammastep.
  location.provider = "geoclue2";
}
