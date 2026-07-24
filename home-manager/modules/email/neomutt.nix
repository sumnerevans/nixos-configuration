{
  config,
  lib,
  pkgs,
  ...
}:
with pkgs;
with lib;
let
  aliasfile = "${config.xdg.configHome}/neomutt/aliases";

  syncthingdir = "${config.home.homeDirectory}/Syncthing";
in
{
  options.mdf.port = mkOption {
    type = types.int;
    description = "The port for the mdf daemon to use";
  };

  config = {
    home.file."bin/mutt_helper" = lib.mkIf (config.wayland.enable || config.xorg.enable) {
      text = ''
        #!/usr/bin/env sh
        set -xe
        if [[ $# == 0 ]]; then
          ${pkgs.kitty}/bin/kitty -T Mutt \
            zsh -c "export FOR_MUTT_HELPER=1 && source ${config.programs.zsh.dotDir}/.zshrc && neomutt"
        else
          ${pkgs.kitty}/bin/kitty -T Mutt \
            zsh -c "export FOR_MUTT_HELPER=1 && source ${config.programs.zsh.dotDir}/.zshrc && neomutt \"$@\""
        fi
      '';
      executable = true;
    };

    home.symlinks."${aliasfile}" = "${syncthingdir}/.config/neomutt/aliases";

    systemd.user.services.mdf = {
      Unit.Description = "Run the mut display filter daemon for serving redirect pages.";

      Service = {
        ExecStart = ''
          ${pkgs.mdf}/bin/mdf \
            --daemon \
            --port ${toString config.mdf.port} \
            --root-uri "http://localhost:${toString config.mdf.port}/"
        '';
        Restart = "always";
        RestartSec = 5;
      };

      Install.WantedBy = [ "default.target" ];
    };

    programs.neomutt = {
      enable = true;
      vimKeys = true;
      binds = [
        {
          action = "complete-query";
          key = "<Tab>";
          map = [ "editor" ];
        }
        {
          action = "group-reply";
          key = "R";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "sidebar-prev";
          key = "\\Cp";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "sidebar-next";
          key = "\\Cn";
          map = [
            "index"
            "pager"
          ];
        }
        {
          action = "sidebar-open";
          key = "\\Co";
          map = [
            "index"
            "pager"
          ];
        }
      ];
      macros = [
        {
          action = "!systemctl --user start mbsync &^M";
          key = "<F5>";
          map = [ "index" ];
        }
        {
          action = "<change-folder>?<change-dir><home>^K=<enter><tab>";
          key = "c";
          map = [ "index" ];
        }
        {
          action = "<save-message>?<tab>";
          key = "s";
          map = [ "index" ];
        }
        {
          action = "<change-folder>${config.accounts.email.accounts.Personal.maildir.absPath}/INBOX<enter>";
          key = "P";
          map = [ "index" ];
        }
        {
          action = "<change-folder>${config.accounts.email.accounts.Gmail.maildir.absPath}/INBOX<enter>";
          key = "A";
          map = [ "index" ];
        }
      ];

      sidebar = {
        enable = true;
        width = 40;
        format = "%B%?F? [%F]?%* %?N?%N/?%S";
        shortPath = false;
      };

      settings = {
        alias_file = aliasfile;
        confirmappend = "no";
        edit_headers = "yes";
        fast_reply = "yes";
        folder = "${config.home.homeDirectory}/Mail";
        imap_check_subscribed = "yes";
        include = "yes";
        mail_check = "0";
        mail_check_stats = "yes";
        mailcap_path = "${config.xdg.configHome}/neomutt/mailcap";
        mark_old = "no";
        markers = "no";
        pager_context = "3";
        pager_index_lines = "10";
        pager_stop = "yes";
        sort_aux = "reverse-last-date-received";
        sort_re = "yes";
        tmpdir = "${config.home.homeDirectory}/tmp";
      };

      extraConfig = ''
        source ${aliasfile}
        mailboxes `${pkgs.findutils}/bin/find ${config.home.homeDirectory}/Mail/ -type d -name cur | ${pkgs.gnused}/bin/sed -e 's:/cur/*$::' -e 's/ /\\ /g' | ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/tr '\n' ' '`

        set allow_ansi
        set display_filter="${pkgs.mdf}/bin/mdf --root-uri 'http://localhost:${toString config.mdf.port}/'"

        # Use return to open message because I'm not a savage
        unbind index <return>
        bind index <return> display-message

        # Use N to toggle new
        unbind index N
        bind index N toggle-new

        # Status Bar
        set status_chars  = " *%A"
        set status_format = "───[ Folder: %f (%l %s/%S)]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)?%?F? (%F flagged)?]───%>─%?p?( %p postponed)?───"

        lists .*@lists.sr.ht

        # ====== COLORS ======
        # Use "default" instead of hardcoded black/white so neomutt follows
        # the terminal's current fg/bg, which kitty/DMS already keep in sync
        # with the light/dark theme.
        color attachment        yellow          default
        color prompt            yellow          default
        color message           default         default
        color error             red             default
        color indicator         black           yellow
        color status            brightwhite     blue
        color tree              magenta         default
        color normal            default         default
        color markers           brightyellow    default
        color search            black           yellow

        # Index
        color index             brightcyan      default ~N # unread
        color index             default         default ~O # read
        color index             brightgreen     default ~F # flagged
        color index             red             default ~D # deleted

        # Header
        color hdrdefault        default         default
        color header            brightgreen     default (^Subject\:)

        # Color Links blue
        color body              brightblue      default "(ftp|http|https)://[^ ]+"
        color body              brightblue      default [-a-z_0-9.]+@[-a-z_0-9.]+

        # Color signature verification
        color body              brightgreen     default "^(gpg: )?Good signature"
        color body              brightgreen     default "^(gpg: )?Encrypted"
        color body              brightred       default "^(gpg: )?Bad signature"
        color body              red             default "^(gpg: )?Problem signature from:.*"
        color body              red             default "^(gpg: )?warning:"
        color body              red             default "^(gpg: ).*failed:"

        # Body
        color quoted             cyan           default
        color signature          cyan           default

        # Sidebar
        color sidebar_highlight default         color8
        color sidebar_new       cyan            default
      '';
    };
  };
}
