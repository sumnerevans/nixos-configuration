#########################
##### Custom Prompt #####
#########################

autoload -Uz promptinit && promptinit
setopt prompt_subst

# Keep track of when the command started for the timer in the prompt.
function preexec() {
    cmd_start=$SECONDS
}

# Just a modified version of adam1
function __lprompt {
    # If we are in a non-TMUX SSH connection, show yellow "[SSH]".
    if [[ -n $SSH_CONNECTION && ! -n $TMUX ]]; then
        echo -n "%B%F{yellow}[SSH]%f%b "
    fi

    lprompt_color="%F{cyan}"
    extra_lprompt=" "
    if [[ $BEEPER_ENV == "production" && ! -n $BEEPER_READONLY ]]; then
        lprompt_color="%F{red}"
        extra_lprompt=" (🚨 PRODUCTION 🚨) "
    fi

    echo "%B${lprompt_color}%~${extra_lprompt}%F{white}%# %b%f"
}

function __rprompt {
    # Capture result of last command. This is displayed at the end of the
    # prompt.
    if [[ $? -eq 0 ]]; then
        RESULT="[%F{green}%?%f]"
    else
        RESULT="[%F{red}%B%?%b%f]"
    fi

    if [ $cmd_start ]; then
        timer_show=$(($SECONDS - $cmd_start))
        echo -n "[%F{cyan}${timer_show}s%f]"
    fi

    # Local variables for color
    local YELLOW="%F{yellow}"
    local GREEN="%F{green}"
    local RED="%F{red}"
    local RESET="%f"

    # If we are in a Python virtual environment, show its name.
    if [[ -n $VIRTUAL_ENV ]]; then
        echo -n "["
        echo -n $GREEN
        echo -n "VE: "
        if [[ $(basename $VIRTUAL_ENV) == ".venv" ]]; then
            echo -n "$(basename $(dirname $VIRTUAL_ENV))/.venv"
        else
            echo -n "$(basename $VIRTUAL_ENV)"
        fi
        echo -n $RESET
        echo -n "]"
    fi

    # If we are in a Git repo, show the branch and the status, as well as
    # whether we need to push/pull.
    git rev-parse --git-dir >& /dev/null  # Detect git repo
    if [[ $? == 0 ]]; then
        echo -n "["

        if [[ $(git ls-files --others --exclude-standard | wc -l) != 0 ]]; then
            # Untracked files
            echo -n "${RED}U$(git ls-files --others --exclude-standard | wc -l) "
        else
            if [[ $(git status --porcelain | wc -l) != 0 ]]; then
                # Files have been modified, dirty.
                echo -n $YELLOW

                staged=$(git status --porcelain | grep '^M' | wc -l)

                # If files have been staged for commit, add a "+"
                [[ $staged != 0 ]] && echo -n "+$staged "
            else
                echo -n $GREEN
            fi
        fi

        # Show the branch name.
        branch_name=$(git branch | command grep '* ' | sed 's/\* \(.*\)/\1/')
        if [[ $branch_name == "" ]]; then
            echo -n 'No Branch'
        else
            echo -n $branch_name

            # Determine if need to pull or not
            UPSTREAM=${1:-'@{u}'}
            LOCAL=$(git rev-parse @ 2&>/dev/null)
            REMOTE=$(git rev-parse "$UPSTREAM" 2&>/dev/null)
            BASE=$(git merge-base @ "$UPSTREAM" 2&>/dev/null)

            if [[ $LOCAL != $REMOTE && $REMOTE != "" ]]; then
                echo -n " ("
                if [ $LOCAL = $BASE ]; then
                    echo -n "v" # Need to pull
                elif [ $REMOTE = $BASE ]; then
                    echo -n "^" # Need to push
                else
                    echo -n "^v" # Diverged
                fi
                echo -n ")"
            fi
        fi
        echo -n $RESET
        echo -n "]"
    fi

    # Echo the result of the previous call.
    echo -n $RESULT
}

export PROMPT='$(__lprompt)'
export RPS1='$(__rprompt)'
