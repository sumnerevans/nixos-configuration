{ pkgs, ... }:
let
  grep = "${pkgs.gnugrep}/bin/grep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";

  headphones = "alsa_output.usb-Lenovo_ThinkPad_USB-C_Dock_Audio_000000000000-00.analog-stereo";
  speakers = "alsa_output.usb-Audioengine_Audioengine_2_-00.analog-stereo";

  currentAudioDevice = pkgs.writeShellScript "current-audio-device" ''
    ${pactl} info | ${grep} 'Default Sink' | ${pkgs.coreutils}/bin/cut -d ':' -f 2
  '';

  # If it's on the headphones, toggle to speakers. Otherwise, toggle to the
  # headphones by default.
  toggleAudio = pkgs.writeShellScript "toggle-audio" ''
    if [[ $(${currentAudioDevice}) =~ "${headphones}" ]]; then
      ${pactl} set-default-sink ${speakers}
    else
      ${pactl} set-default-sink ${headphones}
    fi
  '';
in
{
  wayland.enable = true;
  niri.enable = true;
  laptop.enable = true;
  networking.interfaces = [
    "enp52s0f4u1u1"
    "wlp1s0"
  ];

  mdf.port = 1024;

  home.packages = [ pkgs.pulseaudio ];

  programs.i3status-rust.extraBlocks =
    let
      cmd = "${toggleAudio} && kill -USR1 $(${pkgs.procps}/bin/pgrep i3status-rs)";
    in
    [
      {
        block = "toggle";
        format = "  $icon  ";
        command_state = "[[ $(${currentAudioDevice}) =~ '${speakers}' ]] || echo 1";
        interval = 3;
        priority = 89;
        command_on = cmd;
        command_off = cmd;
      }
    ];
}
