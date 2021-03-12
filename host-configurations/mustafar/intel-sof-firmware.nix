{ lib, fetchurl }: with lib;
stdenv.mkDerivation rec {
  pname = "intel-sof-firmware";
  version = "1.5.0";

  src = ./sof-topology-hatch-1.5.tar.xz;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware/intel/sof-tplg

    cp * $out/lib/firmware/intel/sof-tplg
  '';
}
