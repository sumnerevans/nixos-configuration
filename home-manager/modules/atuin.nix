{ config, lib, ... }:
{
  # Shell history in SQLite, with a frecency-ranked Ctrl+R search.
  programs.atuin = {
    enable = true;

    # Up is bound to zsh's prefix history search in zsh/key-widgets.zsh.
    flags = [ "--disable-up-arrow" ];

    # The daemon keeps an in-memory index that "daemon-fuzzy" search uses for
    # frecency ranking.
    daemon.enable = true;

    settings = {
      search_mode = "daemon-fuzzy";
      filter_mode = "global";
      # Ctrl+R in the search cycles global -> host -> session -> directory ->
      # workspace (the current Git repository).
      workspaces = true;

      style = "compact";
      inline_height = 20;
      keymap_mode = "auto"; # follow zsh's vi insert/command mode
      enter_accept = false; # put the selected command on the line without running it

      update_check = false; # managed by Nix

      # Don't record the same commands that zsh doesn't.
      history_filter = map (p: "^(${p})$") config.programs.zsh.history.ignorePatterns;
    };
  };

  # Atuin owns Ctrl+R, so don't bind fzf's history widget to it.
  programs.fzf.historyWidget.zsh.command = "";

  # Atuin binds "?" on an empty line to its AI chat. Make it a normal key.
  programs.zsh.initContent = lib.mkAfter ''
    bindkey -M viins '?' self-insert
  '';
}
