{ config, pkgs, ... }:
{
  imports = [ ./audio-control-scripts.nix ];

  wayland.enable = true;
  networking.interfaces = [
    "enp37s0"
    "wlp35s0"
  ];

  mdf.port = 1024;

  programs.i3status-rust.extraBlocks =
    let
      cmd = "${config.home.homeDirectory}/bin/toggle-audio && kill -USR1 $(${pkgs.procps}/bin/pgrep i3status-rs)";
    in
    [
      {
        block = "toggle";
        format = "  $icon  ";
        command_state = "[[ $(${config.home.homeDirectory}/bin/current-audio-device) =~ 'alsa_output.usb-Audioengine_Audioengine_2_-00.analog-stereo' ]] || echo 1";
        interval = 3;
        priority = 89;
        command_on = cmd;
        command_off = cmd;
      }
    ];

  wayland.windowManager.sway.config.keybindings."${config.windowManager.modKey}+m" =
    "exec ${pkgs.dbus}/bin/dbus-send --session --dest=net.sourceforge.mumble.mumble --type=method_call '/' 'net.sourceforge.mumble.Mumble.toggleSelfMuted'";
}
