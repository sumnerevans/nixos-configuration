{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    ./aliases.nix
    ./completion.nix
    ./dir-hashes.nix
    ./functions.nix
    ./plugins.nix
  ];

  config = {
    programs.zsh = {
      enable = true;
      defaultKeymap = "viins";
      dotDir = "${config.xdg.configHome}/zsh";

      sessionVariables = {
        # Make Rust blow up verbosely
        RUST_BACKTRACE = 1;

        # Pipenv
        PIPENV_MAX_DEPTH = 10000; # basically infinite
        PIPENV_VENV_IN_PROJECT = 1; # store the virtual environment in .venv in the project directory
      };

      setOptions = [
        "extendedglob"
        "autopushd"
        "nobeep" # Don't beep ever
      ];

      history = {
        ignoreAllDups = true;
        extended = true;
        path = "${config.home.homeDirectory}/.histfile";
        # The default of 10000 silently truncates the history file.
        size = 100000;
        save = 100000;

        ignorePatterns = [
          "clear"
          "exit"

          # Ignore the git commands I use a lot
          "gaa"
          "gd"
          "gl"
          "gs"

          # Ignore directory listing commands
          "l"
          "ll"

          # Ignore showing current time tracking status
          "tt"
        ];
      };

      initContent = lib.mkBefore ''
        # If inside of an SSH session, run tmux.
        if [[ -n $SSH_CONNECTION ]]; then
          if command -v tmux &> /dev/null &&
             [ -n "$PS1" ] &&
             [[ ! "$TERM" =~ screen ]] &&
             [[ ! "$TERM" =~ tmux ]] &&
             [ -z "$TMUX" ]; then
            exec tmux attach && exit
          fi
        fi

        if [[ $FOR_MUTT_HELPER != 1 ]]; then

          ${builtins.readFile ./key-widgets.zsh}
          ${builtins.readFile ./prompt.zsh}
          ${builtins.readFile ./git-repo-nav.zsh}

          print -P "%B========================================================================%b"

          # Show a quote
          ${pkgs.fortune}/bin/fortune ${config.xdg.dataHome}/fortune/quotes

          print -P "%B========================================================================%b"
        fi
      '';
    };

    programs.direnv.enableZshIntegration = true;
    programs.fzf.enableZshIntegration = true;
    programs.opam.enableZshIntegration = true;
    programs.zsh.fastSyntaxHighlighting.enable = true;

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/go/bin"
    ];
  };
}
