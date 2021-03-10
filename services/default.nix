{ config, pkgs, ... }:
{
  imports = [
    ./syncthing.nix
    ./window-manager/default.nix
  ];

  # List services that you want to enable:
  # ===========================================================================

  # Suspend on power button press instead of shutdown.
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  # Enable Flatpak.
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Fix some bugs with various services.
  services.gnome3.at-spi2-core.enable = true;

  # Enable the system keyring.
  services.gnome3.gnome-keyring.enable = true;

  # Gnome Crypto services
  services.dbus.packages = [ pkgs.gcr ];

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
}
