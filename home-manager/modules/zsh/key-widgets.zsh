##############################
##### Custom Key Widgets #####
##############################

function __zkey_prepend_man {
    if [[ $BUFFER != "man "*  ]]; then
        BUFFER="man $BUFFER"
        CURSOR+=4
    else
        BUFFER="${BUFFER:4}"
    fi
}
zle -N prepend-man __zkey_prepend_man

function __zkey_prepend_sudo {
    if [[ $BUFFER != "sudo "*  ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR+=5
    else
        BUFFER="${BUFFER:5}"
    fi
}
zle -N prepend-sudo __zkey_prepend_sudo

function __zkey_prepend_vim {
    if [[ $BUFFER != "vim "*  ]]; then
        BUFFER="vim $BUFFER"
        CURSOR+=4
    else
        BUFFER="${BUFFER:4}"
    fi
}
zle -N prepend-vim __zkey_prepend_vim

function __zkey_append_dir_up {
    [[ $LBUFFER = *.. ]] && LBUFFER+="/.." || LBUFFER+="."
}
zle -N append-dir-up __zkey_append_dir_up

function __zkey_delete_dir_up {
    if [[ $LBUFFER = */..  ]] then
        CURSOR=CURSOR-3
        BUFFER="$LBUFFER${RBUFFER:${CURSOR+3}}"
    else
        # Move the cursor back and reset delete the previous character from the buffer.
        CURSOR=CURSOR-1
        BUFFER="$LBUFFER${RBUFFER:${CURSOR+1}}"
    fi
}
zle -N delete-dir-up __zkey_delete_dir_up

# Key Bindings
bindkey -M vicmd q push-line
bindkey -M vicmd "m" prepend-man
bindkey -M vicmd "s" prepend-sudo
bindkey -M vicmd "v" prepend-vim
bindkey "." append-dir-up
bindkey "^?" delete-dir-up
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char
bindkey "\e[3~" delete-char

# Up arrow search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
