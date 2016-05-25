# Hints: http://superuser.com/questions/789448/choosing-between-bashrc-profile-bash-profile-etc

settitle() {
    echo -ne "\033k$@\033\\"
}

shorthostname() {
    ##  Due to differences in RHEL (hostname -s) & Cygwin (no -s option for hostname)
    IN_TEXT=`hostname`
    HOST=(${IN_TEXT//\./ })
    echo ${HOST}
}

# From RHEL... handy
pathmunge () {
    if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
	if [ "$2" = "after" ] ; then
	    PATH=$PATH:$1
      	else
    	    PATH=$1:$PATH
 	fi
    fi
}

function awslookup (){
  if [ "$#" -ne 2 ]; then
    echo "Not enough arguments, arguments $1 Tag name value, $2 profile name"
    return 1
  fi

  tag=*$1*
  aws ec2 describe-instances \
               --output table \
               --filters "Name=tag-key,Values=Name" "Name=tag-value,Values=$tag" "Name=instance-state-code,Values=16" \
               --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, InstanceId]' \
               --profile $2
}

case "$-" in
*i*)
    if [ -f ~/.ssh/source-ssh-agent ] ; then
        if [ "${SSH_AUTH_SOCK}" != "" ] ; then
            export SSH_AUTH_SOCK_ORIG="${SSH_AUTH_SOCK}"
        fi
        source ~/.ssh/source-ssh-agent
        if [[ "$(uname)" == "Darwin" ]] ; then
            if [[ `ps -p 1916 | grep -q ssh-agent` -ne 0 ]] ; then
                NO_AGENT=true
            fi
        else
            if [[ ! -d "/proc/${SSH_AGENT_PID}/" ]] ; then
                NO_AGENT=true
            fi
        fi

        if [[ ! -z "${NO_AGENT}" ]] ; then
            echo 'SSH-Agent is dead...'
            export SSH_AUTH_SOCK="${SSH_AUTH_SOCK_ORIG}"
            unset SSH_AUTH_SOCK_ORIG
            unset SSH_AGENT_PID
        fi
    fi

    # Aliases, etc.
    alias vi='vim'

    alias sb='sudo bash'
    alias sx='screen -x'

    alias ll='ls -la'
    alias duh='du -m -x --max-depth=1 | sort -n'

    alias wgetx='wget --no-check-certificate'

    if [[ "$(uname)" == "Darwin" ]] ; then
        alias egrep='/usr/local/bin/gegrep'
        alias grep='/usr/local/bin/ggrep'
    fi

    socatnc() {
        socat - TCP4:$@
    }

    if [ -x /usr/bin/colordiff ] ; then
        alias diff='/usr/bin/colordiff -u'
    else
        alias diff='/usr/bin/diff -u'
    fi
    alias sudo='sudo '

    ##  Disable XON/XOFF
    stty -ixon

    # Prompt setting
    source .pj_colours
    PS_USER="$(if [[ ${EUID} == 0 ]]; then echo -n ${lt_red}; else echo -n ${dk_green}; fi)\u"
    PS_GIT="\$(git branch > /dev/null 2>&1 ; \
    if [ \$? -eq 0 ] ; then \
        echo -n '${lt_blue}\w' ; \
        echo -n ' ${dk_blue}(' ; \
        echo -n \`git rev-parse --abbrev-ref HEAD 2> /dev/null\` ; \
        echo -n ')' ; \
    else
        echo -n '${dk_blue}\w' ; \
    fi)"
    PS_EXIT="\$(if [[ -f /tmp/pjay_last_exit ]] ; then cat /tmp/pjay_last_exit ; fi)"
    PS_LINE0="\$(echo \$? > /tmp/pjay_last_exit)"
    PS_LINE1="${PS_USER}${no_color}@${dk_green}\h ${PS_GIT}${no_color}"
    PS_LINE2="${lt_gray}j:\j ${dk_red}e:${PS_EXIT} ${dk_cyan}h:\! ${no_color}\$ "
    export PS1="${PS_LINE0}\n${PS_LINE1}\n${PS_LINE2}"
    ;;
esac

case "$TERM" in
screen)
    settitle "`shorthostname`"

    ##  Call st after ssh has exited
    ssh() {
        command -p ssh $@
        SSH_EC=$?
        if [ $SSH_EC -eq 0 ]; then
            settitle "`shorthostname`"
        else
            settitle "`shorthostname` [ssh exited non-zero]"
            python -c "import sys; sys.exit(${SSH_EC})"
        fi
    }
    ;;

esac

pathmunge ${HOME}/bin

export INPUTRC=/etc/inputrc

export VISUAL=/usr/bin/vim
export EDITOR=${VISUAL}
export SVN_EDITOR=${EDITOR}
export GIT_EDITOR=${EDITOR}

export LESS="-RX -+F"

export LC_COLLATE=C
export LANG=en_US.UTF-8

# Source platform bashrc
if [ -f ~/.profile.platform ]; then
    . ~/.profile.platform
fi

# Source local bashrc
if [ -f ~/.profile.local ]; then
    . ~/.profile.local
fi
