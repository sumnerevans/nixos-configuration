{ pkgs, ... }:
let
  # Piper voices, pinned to a commit of https://huggingface.co/rhasspy/piper-voices.
  voicesRev = "e5349433ed883a32f893a434dc43a6c66b95ef7c";
  fetchVoice =
    path: name: hashes:
    let
      base = "https://huggingface.co/rhasspy/piper-voices/resolve/${voicesRev}/${path}/${name}";
    in
    [
      {
        name = "${name}.onnx";
        path = pkgs.fetchurl {
          url = "${base}.onnx";
          hash = hashes.model;
        };
      }
      {
        name = "${name}.onnx.json";
        path = pkgs.fetchurl {
          url = "${base}.onnx.json";
          hash = hashes.config;
        };
      }
    ];

  voices = pkgs.linkFarm "piper-voices" (
    fetchVoice "en/en_US/ryan/high" "en_US-ryan-high" {
      model = "sha256-s5kNdgbhg+yNv7pwpGBwdPFi3hoMQS4BgNH/YLsVTso=";
      config = "sha256-xtO5jwgxXLS+vw1J1Q/E/0kbUDxkuUDNPVyihUO0gBE=";
    }
    ++ fetchVoice "en/en_US/ryan/medium" "en_US-ryan-medium" {
      model = "sha256-M7UxBuBJ9opR8BTk+hC/WgTg99ZmhpLcBSKMxFVMHXE=";
      config = "sha256-0pBhZ15mARPVH4FlDpIhNNlMq3UCcfnOK8sFEh+SWmA=";
    }
    ++ fetchVoice "en/en_US/lessac/high" "en_US-lessac-high" {
      model = "sha256-TKv3w6Y4AXE380oVFlIgMtT+PzgiioQ8ybdk3cvNngk=";
      config = "sha256-20K5fZhZ8le8FWG47ZgOf7I5hAIFCnTd1svskxqSQS8=";
    }
  );

  say = pkgs.writeShellApplication {
    name = "say";
    runtimeInputs = with pkgs; [
      coreutils
      jq
      mpv
      piper-tts
    ];
    text = ''
      usage() {
        echo "usage: say [-v voice] [-s length-scale] [text...]" >&2
        echo "Reads text from the arguments, or from stdin if none are given." >&2
        echo "Controls: space pause, [ ] speed, backspace reset speed, ←/→ seek, q quit." >&2
        local v
        printf 'Voices:' >&2
        for v in ${voices}/*.onnx; do
          v=''${v##*/}
          printf ' %s' "''${v%.onnx}" >&2
        done
        echo >&2
        exit "''${1:-1}"
      }

      voice=en_US-ryan-medium
      scale=1.0
      while getopts "v:s:h" opt; do
        case "$opt" in
          v) voice="$OPTARG" ;;
          s) scale="$OPTARG" ;;
          h) usage 0 ;;
          *) usage ;;
        esac
      done
      shift $((OPTIND - 1))

      model="${voices}/$voice.onnx"
      [[ -e "$model" ]] || { echo "say: unknown voice '$voice'" >&2; usage; }
      rate=$(jq -r '.audio.sample_rate' "$model.json")

      # Read all the text first so that stdin can be the terminal for mpv's
      # controls, even when the text was piped in.
      text=$(mktemp -t say.XXXXXX)
      trap 'rm -f "$text"' EXIT
      if (($#)); then
        printf '%s\n' "$*" >"$text"
      else
        cat >"$text"
      fi

      mpv_args=(
        --no-config
        --no-video
        --force-window=no
        --term-osd-bar
        --speed=2
        --cache=yes
        --demuxer-max-bytes=512MiB
        --demuxer-max-back-bytes=512MiB
        --demuxer=rawaudio
        --demuxer-rawaudio-rate="$rate"
        --demuxer-rawaudio-channels=1
        --demuxer-rawaudio-format=s16le
      )

      # Stream Piper's audio to mpv as it is generated, on fd 3.
      if { : </dev/tty; } 2>/dev/null; then
        mpv "''${mpv_args[@]}" fd://3 \
          3< <(piper -m "$model" --length-scale "$scale" --output-raw <"$text" 2>/dev/null) \
          </dev/tty
      else
        mpv "''${mpv_args[@]}" --no-terminal fd://3 \
          3< <(piper -m "$model" --length-scale "$scale" --output-raw <"$text" 2>/dev/null) \
          </dev/null
      fi
    '';
  };
in
{
  home.packages = [ say ];
}
