{ pkgs, ... }:
let
  offlinemsmtp = pkgs.callPackage ../pkgs/offlinemsmtp.nix { };
in
{
  home.packages = with pkgs; [
    gh
    hub
    lab
    git-get
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;

    attributes = [ "*.pdf diff=pdf" ];

    signing = {
      key = "8904527AB50022FD";
      signByDefault = true;
      format = "openpgp";
    };

    settings = {
      alias = {
        "s" = "show --ext-diff";
      };
      user.name = "Sumner Evans";
      user.email = "me@sumnerevans.com";

      core.editor = "nvim";
      diff = {
        colorMoved = "default";
        submodule = "log";
      };
      init.defaultBranch = "master";
      pull.ff = "only";
      status.submoduleSummary = true;
      rebase.autoSquash = true;
      rerere.enabled = true;

      sendemail = {
        annotate = "yes";
        smtpserver = "${offlinemsmtp}/bin/offlinemsmtp";
        smtpserveroption = [
          "-a"
          "Personal"
          "--"
        ];
      };
    };

    ignores = [
      "*.orig"
      "*_BACKUP_*"
      "*_BASE_*"
      "*_LOCAL_*"
      "*_REMOTE_*"
      ".ccls-cache"
      ".mypy_cache"
      ".rooter_root"
      ".ropeproject"
      ".stylelintrc"
      ".venv"
      "__pycache__"
      ".direnv"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.zsh.shellAliases = {
    ga = "git add";
    gaa = "git add -A";
    gap = "git add -p";
    gc = "git commit --signoff";
    gca = "gc -a";
    gcaa = "gca --amend";
    gcan = "gc --amend --no-edit";
    gcaan = "gcaa --no-edit";
    gch = "git checkout";
    gd = "git diff";
    gdc = "git diff --cached";
    gfetch = "git fetch";
    gl = "git log --pretty=format:'%C(auto)%h %ad %C(green)%s%Creset %C(auto)%d [%an]' --graph --date=format:'%Y-%m-%d %H:%M' --all";
    gpull = "git pull";
    gpush = "git push";
    grhh = "git reset --hard HEAD";
    gs = "git status";
    gsh = "git show --ext-diff";
    gst = "git stash";
  };
}
