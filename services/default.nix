{ config, pkgs, ... }:
{
  imports = [
    ./clipmenu.nix
    ./kdeconnect.nix
    ./mailfetch.nix
    ./mailnotify.nix
    ./offlinemsmtp.nix
    ./picom.nix
    ./syncthing.nix
    ./vdirsyncer.nix
    ./wallpaper.nix
    ./window-manager/default.nix
    ./writeping.nix
  ];

  # List services that you want to enable:
  # ===========================================================================

  # Suspend on power button press instead of shutdown.
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  # Enable bluetooth.
  services.blueman.enable = true;

  # Enable Flatpak.
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Fix some bugs with various services.
  services.gnome3.at-spi2-core.enable = true;

  # Enable the system keyring.
  services.gnome3.gnome-keyring.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.ports = [ 32 ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Thumbnailing service
  services.tumbler.enable = true;
}
