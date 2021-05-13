{ config, pkgs, ... }:
{
  imports = [
    ./autoupgrade.nix
    ./flatpak.nix
    ./i3wm.nix
    ./sshd.nix
    ./sway.nix
  ];

  # Suspend on power button press instead of shutdown.
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  # Add some Gnome services to make things work.
  services.dbus.packages = with pkgs; [ gnome.dconf gcr ];
  services.gnome.at-spi2-core.enable = true;
  services.gnome.gnome-keyring.enable = true;

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
