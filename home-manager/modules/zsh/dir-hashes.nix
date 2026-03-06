{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  programs.zsh.dirHashes = rec {
    dl = "${home}/Downloads";
    pass = "${home}/.local/share/password-store";
    pics = "${home}/Pictures";
    st = "${home}/Syncthing";
    scratch = "${home}/scratch";
    tmp = "${home}/tmp";
    vid = "${home}/Videos";

    # Documents
    doc = "${home}/Documents";
    ch = "${doc}/cheatsheets";
    no = "${doc}/notes";
    pres = "${doc}/presentations";

    # Teaching
    sch = "${home}/school";
    tea = "${sch}/teaching";

    # NixOS config
    cfg = "/etc/nixos";

    # Repositories
    repo = "${home}/repositories";
    gh = "${repo}/github.com";

    aoc = "${gh}/sumnerevans/advent-of-code";
    hm = "${gh}/nix-community/home-manager";
    hspc = "${gh}/ColoradoSchoolOfMines/hspc-problems";
    kattis = "${gh}/sumnerevans/kattis";
    res = "${gh}/sumnerevans/resume";
    sws = "${gh}/sumnerevans/sumnerevans.com";
    tt = "${gh}/sumnerevans/tracktime";
    yt = "${gh}/sumnerevans/youtube-content";
  };
}
