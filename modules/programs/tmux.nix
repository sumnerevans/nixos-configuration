{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    escapeTime = 0;
    extraConfig = ''
      set -g default-shell ${pkgs.zsh}/bin/zsh

      # Use Alt-HJKL to move around between vim panes and tmux windows.
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind -n M-h if-shell "$is_vim" 'send-keys M-h' 'select-pane -L'
      bind -n M-j if-shell "$is_vim" 'send-keys M-j' 'select-pane -D'
      bind -n M-k if-shell "$is_vim" 'send-keys M-k' 'select-pane -U'
      bind -n M-l if-shell "$is_vim" 'send-keys M-l' 'select-pane -R'

      # Open a new window with Alt-Enter
      bind -n M-Enter split-window -h

      # Use the mouse
      set -g mouse on
    '';
  };
}
