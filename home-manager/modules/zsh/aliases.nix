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
      quotesfile = "vim /etc/nixos/home-manager/modules/email/quotes";

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
      screen = "screen -DR";
      soviet = "${pkgs.pamixer}/bin/pamixer --set-volume 50 && mpv --quiet -vo caca 'https://www.youtube.com/watch?v=U06jlgpMtQs'";
      ssh = "kitten ssh";
      tar = "${pkgs.libarchive}/bin/bsdtar";
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
