{ config, pkgs, ... }:
let
  mkModBind = key: command: ''
    bind -n M-C-${key} ${command}
    bind -n M-${key} ${command}
  '';
  configFilePath = "${config.xdg.configHome}/tmux/tmux.conf";
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    newSession = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [ yank ];

    extraConfig = ''
      # Border color
      set -g pane-active-border-style fg=red,bg=default

      # Use Alt[-Ctrl]-HJKL to move around between vim panes and tmux windows.
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      ${mkModBind "h" "if-shell \"$is_vim\" 'send-keys M-h' 'select-pane -L'"}
      ${mkModBind "j" "if-shell \"$is_vim\" 'send-keys M-j' 'select-pane -D'"}
      ${mkModBind "k" "if-shell \"$is_vim\" 'send-keys M-k' 'select-pane -U'"}
      ${mkModBind "l" "if-shell \"$is_vim\" 'send-keys M-l' 'select-pane -R'"}

      # Open a new window with Alt[-Ctrl]-Enter
      ${mkModBind "Enter" "split-window -h"}

      # Right status
      set -g status-interval 1
      set -g status-right '%Y-%m-%d %H:%M:%S'

      # Use the mouse
      set -gq mouse on

      # Improve copy mode
      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel

      # renumber windows sequentially after closing any of them
      set -g renumber-windows on

      set -ga terminal-overrides ',*256col*:Tc'

      # new window by right click on status line
      bind-key -n MouseDown3Status new-window -a -t= -c '#{pane_current_path}'

      # new window in background by middle click on status line
      bind-key -n MouseDown2Status new-window -ad -t= -c '#{pane_current_path}'

      bind-key R run-shell 'tmux source-file ${configFilePath} > /dev/null; \
                            tmux display-message "Sourced ${configFilePath}!"'
    '';
  };
}
