#########################
##### Custom Prompt #####
#########################

setopt prompt_subst
autoload -Uz add-zsh-hook

# Keep track of when the command started for the timer in the prompt.
function __prompt_preexec {
    __prompt_cmd_start=$SECONDS
}
add-zsh-hook preexec __prompt_preexec

# Compute the dynamic parts of the right prompt. RPROMPT only expands the
# resulting variables.
function __prompt_precmd {
    # Show how long the last command took. Pressing enter on an empty line
    # keeps the previous value.
    if (( ${+__prompt_cmd_start} )); then
        __prompt_timer="[%F{cyan}$(( SECONDS - __prompt_cmd_start ))s%f]"
        unset __prompt_cmd_start
    fi

    # If we are in a Python virtual environment, show its name.
    __prompt_venv=
    if [[ -n $VIRTUAL_ENV ]]; then
        local venv=${VIRTUAL_ENV:t}
        [[ $venv == .venv ]] && venv=${VIRTUAL_ENV:h:t}/.venv
        __prompt_venv="[%F{green}VE: ${venv//\%/%%}%f]"
    fi

    # If we are in a Git repo, show the branch and the status, as well as
    # whether we need to push/pull. Everything comes from a single
    # `git status` call.
    __prompt_git=
    local -a lines ab
    local line branch oid
    integer untracked=0 changed=0 staged=0 ahead=0 behind=0
    lines=("${(@f)$(git status --porcelain=v2 --branch --untracked-files=all 2>/dev/null)}") || return 0
    for line in $lines; do
        case $line in
            ('# branch.oid '*) oid=${line#\# branch.oid } ;;
            ('# branch.head '*) branch=${line#\# branch.head } ;;
            ('# branch.ab '*)
                ab=(${=line#\# branch.ab })
                ahead=${ab[1]#+}
                behind=${ab[2]#-}
                ;;
            ('#'*) ;;
            ('? '*) (( untracked++ )) ;;
            (*)
                (( changed++ ))
                # Count entries whose staged (index) status is "modified".
                [[ $line == 1' M'* ]] && (( staged++ ))
                ;;
        esac
    done

    __prompt_git="["
    if (( untracked )); then
        __prompt_git+="%F{red}U$untracked "
    elif (( changed )); then
        __prompt_git+="%F{yellow}"
        (( staged )) && __prompt_git+="+$staged "
    else
        __prompt_git+="%F{green}"
    fi

    if [[ $oid == '(initial)' ]]; then
        __prompt_git+='No Branch'
    else
        [[ $branch == '(detached)' ]] && branch="(HEAD detached at ${oid[1,7]})"
        __prompt_git+=${branch//\%/%%}
        if (( ahead && behind )); then
            __prompt_git+=" (^v)" # Diverged
        elif (( ahead )); then
            __prompt_git+=" (^)" # Need to push
        elif (( behind )); then
            __prompt_git+=" (v)" # Need to pull
        fi
    fi
    __prompt_git+="%f]"
}
add-zsh-hook precmd __prompt_precmd

PROMPT='%B%F{cyan}%~%f $%b '
# If we are in a non-TMUX SSH connection, show yellow "[SSH]".
if [[ -n $SSH_CONNECTION && -z $TMUX ]]; then
    PROMPT="%B%F{yellow}[SSH]%f%b $PROMPT"
fi

# The exit status of the last command goes at the end.
RPROMPT='${__prompt_timer}${__prompt_venv}${__prompt_git}%(?.[%F{green}%?%f].[%F{red}%B%?%b%f])'
