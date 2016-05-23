# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    if [[ "$(uname)" != "Darwin" ]] ; then  # I don't like Mac's blatting of $PS1
        . /etc/bashrc
    fi
fi

# Merge history
shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups
PROMPT_COMMAND='history -a'

# Source platform bashrc
if [ -f ~/.bashrc.platform ]; then
    . ~/.bashrc.platform
fi

# Source local bashrc
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
