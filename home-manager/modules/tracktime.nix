{
  config,
  pkgs,
  ...
}:
let
  secretsDir = "/etc/nixos/secrets";
  yamlFormat = pkgs.formats.yaml { };
in
{
  home.packages = [ pkgs.tracktime ];

  xdg.configFile."tracktime/tracktimerc" = {
    force = true;
    source = yamlFormat.generate "tracktimerc" {
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

      linear = {
        default_org = "nevarro-space";
        api_key = "${pkgs.coreutils}/bin/cat ${secretsDir}/linear-api-key|";
      };

      sync_time = true;

      day_worked_min_threshold = 120;

      project_rates."teaching/tutoring" = 50;

      reporting = {
        fullname = "Sumner Evans";
        report_statistics = true;
        customer_rates = {
          "Can/Am" = 87.5;
        };
        customer_addresses = {
          "Can/Am" = ''
            8744 Kendrick Castillo Way
            Suite 530
            Highlands Ranch, CO 80129
          '';
        };
      };

      logging = {
        min_level = "debug";
        writers = [
          {
            type = "file";
            format = "json";
            filename = "${config.xdg.stateHome}/tracktime/tracktime.log";
            max_size = 10;
            max_age = 90;
          }
        ];
      };
    };
  };

  # Aliases
  programs.zsh.shellAliases = {
    tt-hspc = "tt start -t gh -p ColoradoSchoolOfMines/hspc-problems";
    tt-nevarro = "tt start -c Nevarro";
    tt-tut = "tt start -c Nevarro -p teaching/tutoring";
  };
}
