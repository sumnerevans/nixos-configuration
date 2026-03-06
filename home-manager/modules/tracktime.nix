{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with pkgs;
let
  secretsDir = "${config.xdg.configHome}/home-manager/secrets";
  tracktime = callPackage ../pkgs/tracktime.nix { };
  yamlFormat = pkgs.formats.yaml { };
in
{
  home.packages = [ tracktime ];

  xdg.configFile."tracktime/tracktimerc".source = yamlFormat.generate "tracktimerc" {
    fullname = "Sumner Evans";
    github = {
      access_token = "${pkgs.coreutils}/bin/cat ${secretsDir}/github-tracktime-access-token|";
      username = "sumnerevans";
    };

    gitlab = {
      api_root = "https://gitlab.com/api/v4/";
      api_key = "${pkgs.coreutils}/bin/cat ${secretsDir}/gitlab-api-key|";
    };

    sourcehut = {
      api_root = "https://todo.sr.ht/api/";
      access_token = "${pkgs.coreutils}/bin/cat ${secretsDir}/sourcehut-access-token|";
      username = "~sumner";
    };

    sync_time = true;
    tableformat = "fancy_grid";

    day_worked_min_threshold = 120;

    project_rates."teaching/tutoring" = 50;
  };

  # Aliases
  programs.zsh.shellAliases = {
    tt-hspc = "tt start -t gh -p ColoradoSchoolOfMines/hspc-problems";
    tt-nevarro = "tt start -c Nevarro";
    tt-tut = "tt start -c Nevarro -p teaching/tutoring";
  };
}
