{ config, pkgs, ... }:
{
  imports = [
    ./clipmenu.nix
    ./kdeconnect.nix
    ./mailfetch.nix
    ./mailnotify.nix
    ./nextcloud.nix
    ./offlinemsmtp.nix
    ./picom.nix
    ./redshift.nix
    ./vdirsyncer.nix
    ./wallpaper.nix
    ./window-manager.nix
    ./writeping.nix
  ];

  # Enable bluetooth
  services.blueman.enable = true;

  # List services that you want to enable:
  # ===========================================================================

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 32 ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the system keyring.
  services.gnome3.gnome-keyring.enable = true;
}
