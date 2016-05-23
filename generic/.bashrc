# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Merge history
shopt -s histappend
export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups

# Source platform bashrc
if [ -f ~/.bashrc.platform ]; then
    . ~/.bashrc.platform
fi

# Source local bashrc
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
