{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.wallpaper;
  xorgCfg = config.xorg;

  doSetWallpaperScriptPart =
    if config.wayland.windowManager.sway.enable then
      ''${pkgs.sway}/bin/swaymsg -s $SWAYSOCK output "*" bg $f1 fill''
    else if config.niri.enable then
      "${pkgs.dms-shell}/bin/dms ipc call wallpaper set $f1"
    else
      "${pkgs.feh}/bin/feh --bg-fill $f1 $f2";

  home = config.home.homeDirectory;
  cu = "${pkgs.coreutils}/bin";
  tmpDir = "${config.home.homeDirectory}/tmp";
  bglistFile = "${tmpDir}/bg_list.txt";
  tmpWallpaper = "${tmpDir}/wallpaper.jpg";

  loadBgListScriptPart =
    let
      loadList = concatMapStringsSep "\n" (
        d:
        if builtins.pathExists d then
          "${pkgs.findutils}/bin/find -L ${d} -type f >> ${bglistFile}"
        else
          throw "${d} is not a directory!"
      );
    in
    if cfg.bgSourceDirs == [ ] then
      throw "At least one source dir required!"
    else
      ''
        ${loadList cfg.bgSourceDirs}
        ${cu}/cat ${bglistFile} | ${cu}/shuf | tee ${bglistFile}
      '';

  dynamicWallpaperScriptPart =
    {
      name,
      wpGroups,
      parentDir ? "Apple",
    }:
    let
      dir = "${home}/Pictures/wallpapers/${parentDir}/${name}";
      zeroPad = x: if x < 10 then "0${toString x}" else toString x;
      mkWpGroup =
        { hours, wpNum }:
        ''
          ${concatMapStringsSep "|" zeroPad hours})
            ${strings.optionalString (
              (length hours) > 1
            ) ''[[ "$h" != ${zeroPad (last hours)} ]] && skip_transition=1''}
            wp_num=${toString wpNum}
            ${strings.optionalString ((length wpGroups) == wpNum) "wp_next=1"}
            ;;
        '';
    in
    ''
      h=$(${cu}/date '+%H')
      m=$(${cu}/date '+%M')
      echo "Setting wallpaper for $h:$m"

      # Chop off leading zero on the minutes.
      [[ "''${m:0:1}" == "0" ]] && m="''${m:1}"

      case $h in
      ${concatMapStringsSep "\n" mkWpGroup wpGroups}
      esac

      # Determine amount to transition
      if [ -z $wp_next ]; then wp_next=$((wp_num + 1)); fi
      wp_transition_level=$(echo "$m / 60 * 100" | ${pkgs.bc}/bin/bc -l)

      echo "wp_num: $wp_num"
      echo "wp_next: $wp_next"
      echo "wp_transition_level: $wp_transition_level"
      echo "skip_transition: $skip_transition"

      if [[ $skip_transition == 1 ]]; then
        f1="${dir}/${name}_$wp_num.jpeg"
      else
        # Composite the picture.
        ${pkgs.imagemagick}/bin/composite \
            -dissolve $wp_transition_level \
            -gravity Center \
            "${dir}/${name}_$wp_next.jpeg" \
            "${dir}/${name}_$wp_num.jpeg" \
            -alpha Set \
            ${tmpWallpaper}
        f1=${tmpWallpaper}
      fi
      ${doSetWallpaperScriptPart}
    '';

  randomBgScriptPart = ''
    # Replenish the background list
    ${cu}/touch ${bglistFile}
    if [[ $(${cu}/wc -l <${bglistFile}) -le 1 ]]; then
      ${loadBgListScriptPart}
    fi

    # Set the background
    f1=$(${cu}/head -1 ${bglistFile})
    f2=$(${pkgs.gnused}/bin/sed "2q;d" ${bglistFile})
    echo "Setting $f1 $f2 as backgrounds"
    ${doSetWallpaperScriptPart}

    # Remove the used images from the top of the file
    tf=$(${cu}/mktemp /tmp/bglisttmp-XXXXXX)
    ${cu}/tail -n +3 ${bglistFile} > $tf
    ${cu}/mv $tf ${bglistFile}
  '';

  setWallpaperScript =
    let
      type =
        if cfg.type == "mojave_dynamic" then
          dynamicWallpaperScriptPart {
            name = "mojave_dynamic";
            wpGroups = [
              {
                hours = [
                  23
                  0
                  1
                  2
                ];
                wpNum = 15;
              }
              {
                hours = [
                  3
                  4
                ];
                wpNum = 16;
              }
              {
                hours = [ 5 ];
                wpNum = 1;
              }
              {
                hours = [ 6 ];
                wpNum = 2;
              }
              {
                hours = [ 7 ];
                wpNum = 3;
              }
              {
                hours = [ 8 ];
                wpNum = 4;
              }
              {
                hours = [ 9 ];
                wpNum = 5;
              }
              {
                hours = [ 10 ];
                wpNum = 6;
              }
              {
                hours = [
                  11
                  12
                ];
                wpNum = 7;
              }
              {
                hours = [
                  13
                  14
                ];
                wpNum = 8;
              }
              {
                hours = [ 15 ];
                wpNum = 9;
              }
              {
                hours = [ 16 ];
                wpNum = 10;
              }
              {
                hours = [ 17 ];
                wpNum = 11;
              }
              {
                hours = [ 18 ];
                wpNum = 12;
              }
              {
                hours = [ 19 ];
                wpNum = 13;
              }
              {
                hours = [
                  20
                  21
                  22
                ];
                wpNum = 14;
              }
            ];
          }
        else if cfg.type == "catalina_dynamic" then
          dynamicWallpaperScriptPart {
            name = "catalina_dynamic";
            wpGroups = [
              {
                hours = [
                  0
                  1
                  2
                ];
                wpNum = 1;
              }
              {
                hours = [
                  3
                  4
                  5
                ];
                wpNum = 2;
              }
              {
                hours = [
                  6
                  7
                  8
                ];
                wpNum = 3;
              }
              {
                hours = [
                  9
                  10
                  11
                ];
                wpNum = 4;
              }
              {
                hours = [
                  12
                  13
                  14
                ];
                wpNum = 5;
              }
              {
                hours = [
                  15
                  16
                  17
                ];
                wpNum = 6;
              }
              {
                hours = [
                  18
                  19
                  20
                ];
                wpNum = 7;
              }
              {
                hours = [
                  21
                  22
                  23
                ];
                wpNum = 8;
              }
            ];
          }
        else if cfg.type == "monterey_dynamic" then
          dynamicWallpaperScriptPart {
            name = "monterey_dynamic";
            parentDir = "levitt";
            wpGroups = [
              {
                hours = [
                  23
                  0
                  1
                  2
                  3
                ];
                wpNum = 2;
              }
              {
                hours = [ 4 ];
                wpNum = 1;
              }
              {
                hours = [ 5 ];
                wpNum = 3;
              }
              {
                hours = [ 6 ];
                wpNum = 4;
              }
              {
                hours = [ 7 ];
                wpNum = 5;
              }
              {
                hours = [ 8 ];
                wpNum = 6;
              }
              {
                hours = [ 9 ];
                wpNum = 7;
              }
              {
                hours = [ 10 ];
                wpNum = 9;
              }
              {
                hours = [ 11 ];
                wpNum = 8;
              }
              {
                hours = [ 12 ];
                wpNum = 10;
              }
              {
                hours = [
                  13
                  14
                ];
                wpNum = 12;
              }
              {
                hours = [
                  15
                  16
                ];
                wpNum = 11;
              }
              {
                hours = [
                  17
                  18
                ];
                wpNum = 13;
              }
              {
                hours = [
                  19
                  20
                ];
                wpNum = 14;
              }
              {
                hours = [
                  21
                  22
                ];
                wpNum = 15;
              }
            ];
          }
        else
          randomBgScriptPart;
    in
    pkgs.writeShellScript "set_wallpaper" ''
      set -xe
      ${type}
    '';
in
{
  options = {
    wallpaper = {
      type = mkOption {
        type = types.enum [
          "mojave_dynamic"
          "catalina_dynamic"
          "monterey_dynamic"
          "random_bg"
        ];
        description = "The kind of wallpaper to use.";
        default = "mojave_dynamic";
      };

      bgSourceDirs = mkOption {
        type = types.listOf types.path;
        description = "Paths to the directories to use for the wallpaper rotation.";
        default = [ ];
      };
    };
  };

  config = mkIf (config.wayland.windowManager.sway.enable || config.niri.enable || xorgCfg.enable) {
    systemd.user.services.wallpaper = {
      Unit = {
        Description = "Set the wallpaper.";
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${setWallpaperScript}";
        Environment = "DISPLAY=:0";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    systemd.user.timers.wallpaper = {
      Unit = {
        Description = "Set the wallpaper";
      };

      Timer = {
        OnCalendar = "*:0/10"; # Every 10 minutes
        Unit = "wallpaper.service";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
