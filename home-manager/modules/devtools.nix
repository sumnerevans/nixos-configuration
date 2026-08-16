{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  tomlFormat = pkgs.formats.toml { };
  iniFormat = pkgs.formats.ini { };
  hasGui = config.wayland.enable || config.xorg.enable;
in
{
  options = {
    devTools.enable = mkEnableOption "developer tools and applications" // {
      default = true;
    };
  };

  config = mkIf config.devTools.enable {
    home.packages =
      with pkgs;
      [
        # Shell Utilities
        eternal-terminal
        mosh
        tree-sitter
        watchexec

        # SQL Terminal GUI
        postgresql
        litecli
        pgcli

        # Better Python REPL
        python3Packages.ptpython
      ]
      ++ (
        # GUI Tools
        optionals hasGui [
          d-spy
          sqlitebrowser

          # GTK Development
          icon-library
        ]
      );

    # Go
    programs.go = {
      enable = true;
      telemetry.mode = "on";
    };

    # Enable developer programs
    programs.claude-code = {
      enable = true;
      settings = {
        tui = "fullscreen";
        theme = "auto";
        editorMode = "vim";
        permissions.defaultMode = "manual";
        permissions.allow = [
          "WebSearch"
          "WebFetch"
          "Read"
          "Grep"
          "Glob"

          # Read-only git commands
          "Bash(git status:*)"
          "Bash(git diff:*)"
          "Bash(git log:*)"
          "Bash(git show:*)"
          "Bash(git blame:*)"
          "Bash(git remote -v)"
          "Bash(git remote show:*)"
          "Bash(git ls-files:*)"
          "Bash(git rev-parse:*)"
          "Bash(git describe:*)"
          "Bash(git stash list:*)"

          # Read-only filesystem/shell commands
          "Bash(ls:*)"
          "Bash(find:*)"
          "Bash(pwd)"
          "Bash(cat:*)"
          "Bash(head:*)"
          "Bash(tail:*)"
          "Bash(wc:*)"
          "Bash(file:*)"
          "Bash(which:*)"

          # Read-only nix commands
          "Bash(nix flake check:*)"
          "Bash(nix flake show:*)"
          "Bash(nix eval:*)"
          "Bash(nixos-rebuild build:*)"
        ];
      };
    };
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.jq.enable = true;

    xdg.configFile."pypoetry/config.toml".source = tomlFormat.generate "config.toml" {
      virtualenvs.in-project = true;
    };

    home.file.".ideavimrc".text = ''
      set clipboard+=unnamed
    '';

    xdg.configFile."pgcli/config".source = iniFormat.generate "config" {
      main = {
        wider_completion_menu = "True";
        log_file = "${config.home.homeDirectory}/.cache/pgcli/log";
        vi = "True";
      };
    };
  };
}
