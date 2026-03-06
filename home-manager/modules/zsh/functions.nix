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
          # Things to perform after a directory change.
          chpwd = ''
            emulate -L zsh

            # Fetch if this is a Git repo.
            [[ -d .git ]] || ${git} rev-parse --git-dir > /dev/null 2>&1
            if [[ "$?" == "0" ]]; then
                echo -e "Fetching from git in the background..."
                (${git} fetch 2&>/dev/null &)
            fi

            export ${chpwd_just_happened}=1
          '';

          # Run right before the prompt.
          precmd = ''
            # If the cd just happend...
            if [[ "''$${chpwd_just_happened}" == "1" ]]; then
              # Automatically list directory contents.
              ${ls} --color -Fa

              if [ -f .pre-commit-config.yaml ]; then
                ${pkgs.pre-commit}/bin/pre-commit install --install-hooks
              fi
            fi
            unset ${chpwd_just_happened}
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

          # Use the https://gitignore.io API to retrieve gitignores
          wgitignore = ''
            ignores=$(printf ",%s" "$*[@]")
            ignores=''${ignores:1}
            set -xe
            ${pkgs.curl}/bin/curl "https://www.toptal.com/developers/gitignore/api/$ignores" >> .gitignore
          '';
        };
    in
    concatStringsSep "\n\n" (mapAttrsToList fnToStr fns);
}
