{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  programs.zsh = {
    shellAliases = {
      ##### Command Shortcuts #####
      # Printing
      alpr = "ssh isengard lpr -P bb136-printer -o coallate=true";
      alprd = "ssh isengard lpr -P bb136-printer -o coallate=true -o Duplex=DuplexNoTumble";
      lpr = "lpr -o coallate=true";
      hlpr = "lpr -P HP_ENVY_4500_series";
      hlprd = "hlpr -o Duplex=DuplexNoTumble";

      # Config
      projectlist = "vim ~st/projectlist && projectsync";
      quotesfile = "vim ${config.xdg.configHome}/home-manager/modules/email/quotes";
      reload = ". ~/.zshrc && echo 'ZSH Config Reloaded from ~/.zshrc'";
      sshconf = "vim ~/.ssh/config";
      vimrc = "realvim ~/.vim/vimrc";

      # Other aliases
      antioffice = "libreoffice --headless --convert-to pdf";
      feh = "feh -.";
      getquote = "fortune ${config.xdg.dataHome}/fortune/quotes";
      grep = "grep --color -n";
      hostdir = "python -m http.server";
      iftop = "sudo iftop -i any";
      journal = "vim ${config.home.homeDirectory}/Documents/journal/$(date +%Y-%m-%d).rst";
      la = "ls -a";
      ll = "ls -lah";
      ls = mkIf config.isLinux "ls --color -F";
      man = "MANWIDTH=80 man --nh --nj";
      myip = "curl 'https://api.ipify.org?format=text' && echo";
      ohea = "echo 'You need to either wake up or go to bed!'";
      open = if config.isLinux then "(thunar &> /dev/null &)" else "open .";
      pdflatex = "pdflatex -shell-escape";
      sbcl = "rlwrap sbcl";
      screen = "screen -DR";
      soviet = "${pkgs.pamixer}/bin/pamixer --set-volume 50 && mpv --quiet -vo caca 'https://www.youtube.com/watch?v=U06jlgpMtQs'";
      tar = "${pkgs.libarchive}/bin/bsdtar";
      wdir = "watch --color -n .5 'ls -lha --color=always'";
      xelatex = "xelatex -shell-escape";
      zathura = "zathura --fork";

      # Use nvim by default if it exists
      realvim = "command vim";
    };

    initContent = ''
      # File Type Associations
      alias -s cpp=$EDITOR
      alias -s doc=$OFFICE
      alias -s docx=$OFFICE
      alias -s exe=$WINE
      alias -s h=$EDITOR
      alias -s md=$EDITOR
      alias -s mp4=$VIDEOVIEWER
      alias -s mkv=$VIDEOVIEWER
      alias -s ods=$OFFICE
      alias -s odt=$OFFICE
      alias -s pdf=zathura
      alias -s ppt=$OFFICE
      alias -s pptx=$OFFICE
      alias -s tex=$EDITOR
      alias -s txt=$EDITOR
      alias -s xls=$OFFICE
      alias -s xlsx=$OFFICE

      # Making GNU fileutils more verbose
      for c in cp mv rm chmod chown rename; do
          alias $c="$c -v"
      done
    '';
  };
}
