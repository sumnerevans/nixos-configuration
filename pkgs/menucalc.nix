{ stdenv, lib, pkgs }: with pkgs;
stdenv.mkDerivation rec {
  pname = "menucalc";
  version = "v1.3.0";

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = "menu-calc";
    rev = version;
    sha256 = "041jj6x1ihg9jkj5lww6cqlvjc9f7m1rfk83dspspqjqb6ibfs5x";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin"
    install -D -m755 ./= "$out/bin/="
    mkdir -p "$out/share/man/man1"
    install -D -m644 ./=.1 "$out/share/man/man1/=.1"
    install -D -m644 ./menu-calc.1 "$out/share/man/man1/menu-calc.1"
  '';

  wrapperPath = with stdenv.lib; makeBinPath [
    bc
    rofi
    xclip
  ];

  fixupPhase = ''
    patchShebangs $out/bin
    wrapProgram $out/bin/= \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "A calculator for Rofi/dmenu(2)";
    homepage = https://github.com/sumnerevans/menu-calc;
    # maintainers = with stdenv.lib.maintainers; [ sumnerevans ];
    license = stdenv.lib.licenses.mit;
    platforms = with stdenv.lib.platforms; linux;
  };
}
