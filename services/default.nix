{ config, pkgs, ... }:
{
  imports = [
    ./clipmenu.nix
    ./kdeconnect.nix
    ./mailfetch.nix
    ./mailnotify.nix
    ./offlinemsmtp.nix
    ./picom.nix
    ./redshift.nix
    ./syncthing.nix
    ./vdirsyncer.nix
    ./wallpaper.nix
    ./window-manager.nix
    ./writeping.nix
  ];

  # List services that you want to enable:
  # ===========================================================================

  # Enable bluetooth.
  services.blueman.enable = true;

  # Enable Flatpak.
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 32 ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the system keyring.
  services.gnome3.gnome-keyring.enable = true;
}
