{
  config,
  lib,
  pkgs,
  ...
}:
with pkgs;
let
  pgrep = "${procps}/bin/pgrep";
  sleep = "${coreutils}/bin/sleep";
  ffmpegFilters = lib.concatStringsSep "," [
    "noise=alls=10"
    "scale=iw*.25:-1"
    "gblur=sigma=5"
    "scale=iw*4:-1:flags=neighbor"
  ];
  imageFile = "${config.home.homeDirectory}/tmp/wallpaper.png";
  fuzzy-lock = pkgs.writeShellScriptBin "fuzzy-lock" ''
    ${pgrep} i3lock && exit

    resolution=$(
      ${xorg.xdpyinfo}/bin/xdpyinfo |
      ${gnugrep}/bin/grep dimensions |
      ${gawk}/bin/awk '{print $2}')

    ${ffmpeg-full}/bin/ffmpeg -y -loglevel 0 \
      -s "$resolution" -f x11grab -i $DISPLAY -vframes 1 \
      -vf "${ffmpegFilters}" ${imageFile}

    ${i3lock}/bin/i3lock -ei ${imageFile} -c 000000

    # Turn off the display after a time
    off_sec=60
    i=0

    while [[ $(${pgrep} i3lock) ]]
    do
      if (( $i > $off_sec )); then
        ${xorg.xset}/bin/xset dpms force off

          until [[ "$(${xorg.xset}/bin/xset -q | ${gnused}/bin/sed -ne 's/^[ ]*Monitor is //p')" == "On" ]]
          do
            ${sleep} 1
          done

          i=0
      fi

      i=$(($i + 1))
      ${sleep} 1
    done
  '';
in
fuzzy-lock
