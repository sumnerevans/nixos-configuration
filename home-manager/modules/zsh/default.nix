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

  options = {
    isLinux = mkEnableOption "Linux support" // {
      default = true;
    };
    isMacOS = mkEnableOption "macOS support";
    autoAddSSHKeysToAgent = mkEnableOption "automatically add SSH keys to the SSH agent" // {
      default = true;
    };
  };

  config = {
    programs.zsh = {
      enable = true;
      defaultKeymap = "viins";
      dotDir = "${config.xdg.configHome}/zsh";

      localVariables = {
        OFFICE = "libreoffice";
        VIDEOVIEWER = "mpv";
        WINE = "wine";
      };

      sessionVariables = {
        # Make Rust blow up verbosely
        RUST_BACKTRACE = 1;

        # Pipenv
        PIPENV_MAX_DEPTH = 10000; # basically infinite
        PIPENV_VENV_IN_PROJECT = 1; # store the virtual environment in .venv in the project directory

        # Use colors!
        TERM = "xterm-256color";
      };

      history = {
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        extended = true;
        path = "${config.home.homeDirectory}/.histfile";

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

      initContent =
        let
          tput = "${pkgs.ncurses}/bin/tput";
          opensshAdd = optionalString config.autoAddSSHKeysToAgent ''
            # Add my key to the ssh-agent if necessary
            ${pkgs.openssh}/bin/ssh-add -l | \
              ${pkgs.gnugrep}/bin/grep "The agent has no identities" && \
              ${pkgs.openssh}/bin/ssh-add
          '';
        in
        lib.mkBefore ''
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

          export TERM=xterm-256color

          if [[ $FOR_MUTT_HELPER != 1 ]]; then

            ${builtins.readFile ./key-widgets.zsh}
            ${builtins.readFile ./prompt.zsh}
            ${builtins.readFile ./git-repo-nav.zsh}

            # Colors
            autoload colors zsh/terminfo
            colors
            ${optionalString config.isLinux "eval $(dircolors -b)"}
            ${optionalString config.isMacOS "export CLICOLOR=1"}

            setopt appendhistory
            setopt extendedglob
            setopt autopushd
            setopt nobeep  # Don't beep ever

            ${opensshAdd}

            echo "$(${tput} bold)======================================================================$(${tput} sgr 0)"

            # Show a quote
            ${pkgs.fortune}/bin/fortune ${config.xdg.dataHome}/fortune/quotes

            echo "$(${tput} bold)======================================================================$(${tput} sgr 0)"
          fi
        '';
    };

    programs.direnv.enableZshIntegration = true;
    programs.fzf.enableZshIntegration = true;
    programs.opam.enableZshIntegration = true;

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.cargo/bin"
      "${config.home.homeDirectory}/go/bin"
    ];
  };
}
