# CTRL-G - go to a git repository. Utilizes the current $GITGET_ROOT to list
# the available repositories.
fzf-git-repo-nav() {
  local root=~/repositories
  local cmd="fd --unrestricted -t d '^\.git$' $root | command grep -v $root/.git | sed 's/\/\.git\/$//' | sed \"s|$root/||\" | sort"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_CTRL_G_OPTS-}" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="  builtin cd -- $root/${(q)dir}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}

zle     -N            fzf-git-repo-nav
bindkey -M emacs '^G' fzf-git-repo-nav
bindkey -M vicmd '^G' fzf-git-repo-nav
bindkey -M viins '^G' fzf-git-repo-nav
