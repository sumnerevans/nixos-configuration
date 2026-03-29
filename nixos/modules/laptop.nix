{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.hostCategory == "laptop") {
    environment.homeBinInPath = true;
    services.upower.enable = true;

    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 25;
      efi.canTouchEfiVariables = true;
    };

    # Temporary in-RAM Filesystems.
    fileSystems."/home/sumner/tmp" = {
      fsType = "tmpfs";
      options = [
        "nosuid"
        "nodev"
        "size=${toString config.ramSize}G"
      ];
    };

    networking.networkmanager.enable = true;
    networking.usePredictableInterfaceNames = true;
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Pipewire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };

    # Suspend on power button press instead of shutdown.
    services.logind.settings.Login.HandlePowerKey = "suspend";

    # Enable Flatpak.
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    # Enable YubiKey smart card mode.
    services.pcscd.enable = true;

    # Enable firmware updating
    services.fwupd.enable = true;

    # Enable libvirtd and virt-manager
    virtualisation.libvirtd.enable = true;
    users.users.sumner.extraGroups = [ "libvirtd" ];

    # For flashing ErgoDox and Voyager.
    hardware.keyboard.zsa.enable = true;

    # Extra programs for laptops
    environment.systemPackages = with pkgs; [
      virt-manager
      android-tools
      lm_sensors
    ];

    # Font config
    fonts = {
      packages = with pkgs; [
        font-awesome_4
        iosevka-bin
        noto-fonts
        noto-fonts-color-emoji
        open-sans
        powerline-fonts
        nerd-fonts.terminess-ttf
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [
            "Iosevka"
            "Font Awesome"
          ];
          sansSerif = [ "Open Sans" ];
          serif = [ "Noto Serif" ];
        };
      };
    };

    # Add some Gnome services to make things work.
    programs.dconf.enable = true;
    services.dbus.packages = with pkgs; [
      dconf
      gcr
    ];
    services.gnome.at-spi2-core.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # Printing
    services.printing.enable = true;
    services.avahi = { # For printer discovery
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Thumbnailing service
    services.tumbler.enable = true;

    # Use geoclue2 as the location provider for things like redshift/gammastep.
    location.provider = "geoclue2";
    services.geoclue2.appConfig.redshift = {
      isAllowed = true;
      isSystem = true;
    };

    # DMS + Niri
    programs.dms-shell.enable = true;
    programs.dsearch = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target"; # Only start in graphical sessions
      };
    };
    programs.niri.enable = true;
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = config.users.users.sumner.home;
    };
  };
}
