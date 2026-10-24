{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  programs.zsh.dirHashes = rec {
    dl = "${home}/Downloads";
    doc = "${home}/Documents";
    pics = "${home}/Pictures";
    scratch = "${home}/scratch";
    st = "${home}/Syncthing";
    tmp = "${home}/tmp";
    vid = "${home}/Videos";

    # NixOS config
    cfg = "/etc/nixos";

    # Repositories
    repo = "${home}/repositories";
    gh = "${repo}/github.com";

    aoc = "${gh}/sumnerevans/advent-of-code";
    hm = "${gh}/nix-community/home-manager";
    hspc = "${gh}/ColoradoSchoolOfMines/hspc-problems";
    pres = "${gh}/sumnerevans/presentations";
    res = "${gh}/sumnerevans/resume";
    sws = "${gh}/sumnerevans/sumnerevans.com";
    tt = "${gh}/sumnerevans/tracktime";
  };
}
