{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  programs.zsh.initContent =
    let
      fnToStr = name: body: ''
        function ${name}() {
        ${body}
        }
      '';

      git = "${pkgs.git}/bin/git";
      ls = "${pkgs.coreutils}/bin/ls";
      mv = "${pkgs.coreutils}/bin/mv";

      fns =
        let
          chpwd_just_happened = "__zsh_chpwd_just_happened";
        in
        {
          # Things to perform after a directory change (chpwd hook).
          __on_chpwd = ''
            emulate -L zsh

            # Fetch if this is a Git repo.
            if [[ -d .git ]] || ${git} rev-parse --git-dir &> /dev/null; then
                echo "Fetching from git in the background..."
                ${git} fetch &> /dev/null &!
            fi

            typeset -g ${chpwd_just_happened}=1
          '';

          # Run right before the prompt (precmd hook).
          __on_precmd = ''
            # If the cd just happend...
            if (( ''${+${chpwd_just_happened}} )); then
              unset ${chpwd_just_happened}

              # Automatically list directory contents.
              ${ls} --color -Fa

              # Install the pre-commit hooks if they aren't already.
              if [[ -f .pre-commit-config.yaml && ! -e "$(${git} rev-parse --git-path hooks/pre-commit 2> /dev/null)" ]]; then
                ${pkgs.pre-commit}/bin/pre-commit install --install-hooks
              fi
            fi
          '';

          # "delete" files (use ~/tmp as a recycle bin)
          del = ''
            ${mv} $* ${config.home.homeDirectory}/tmp
          '';

          # Check the spelling of a word using aspell
          # Default to GB spelling, or if the second param exists, use it to
          # specify a different language.
          spell = ''
            if [[ -z "$2" ]]; then; lang="en_GB"; else; lang="$2"; fi
            echo "$1" | ${pkgs.aspell}/bin/aspell -a -l "$lang"
          '';
        };
    in
    concatStringsSep "\n\n" (mapAttrsToList fnToStr fns)
    + ''

      autoload -Uz add-zsh-hook
      add-zsh-hook chpwd __on_chpwd
      add-zsh-hook precmd __on_precmd
    '';
}
