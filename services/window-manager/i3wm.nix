{ config, lib, pkgs, ... }: with lib; let
  cfg = config.xorg;
in
{
  options = {
    xorg = {
      enable = mkOption {
        type = types.bool;
        description = "Enable the Xorg stack";
        default = false;
      };

      xkbVariant = mkOption {
        type = types.str;
        description = "The XKB variant to use";
        default = "";
      };

      remapEscToCaps = mkOption {
        type = types.bool;
        description = "Remap the physical escape key to Caps Lock";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dunst
      flameshot
      lxappearance
      scrot
      xbindkeys
      xclip
      xorg.xbacklight
      xorg.xdpyinfo
      xorg.xprop
    ];

    services.xbanish.enable = true;

    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;
      displayManager.startx.enable = true;

      # Use 3l
      layout = "us";
      xkbVariant = mkIf (cfg.xkbVariant != "") cfg.xkbVariant;

      # Enable touchpad support.
      libinput = {
        enable = true;
        touchpad.tapping = false;
      };

      # Enable i3
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };

    systemd.user.services.xmodmap = mkIf (cfg.remapEscToCaps) (
      let
        xmodmapConfig = pkgs.writeText "Xmodmap.conf" ''
          ! Reverse scrolling
          ! pointer = 1 2 3 5 4 6 7 8 9 10 11 12
          keycode 9 = Caps_Lock Caps_Lock Caps_Lock
        '';
      in
        {
          description = "Run xmodmap on startup.";
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          serviceConfig.ExecStart = "${pkgs.xorg.xmodmap}/bin/xmodmap ${xmodmapConfig}";
        }
    );
  };
}
