#!/bin/sh

# Time-stamp: <04/27/2009 10:48:45 星期一 by ahei>

export TIMESTAMP_HISTDIR="$HOME/.history"
export TIMESTAMP_HISTFILE="$TIMESTAMP_HISTDIR/.history_timestamp"
export TIMESTAMP_HIST_DUP=1

getUserIP()
{
    IFS=$'/' read x x pts <<< "`tty`"
    who | grep "$pts" | sed -r 's/^.*\((.*)\)$/\1/g'
}

timestampHistory()
{
    echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007\n"
    history -a

    if [ ! -d "$TIMESTAMP_HISTDIR" ]; then
        [ -e "$TIMESTAMP_HISTDIR" ] && mv "$TIMESTAMP_HISTDIR" "$TIMESTAMP_HISTDIR".bak
        mkdir "$TIMESTAMP_HISTDIR"
    fi

    dateTime=`date '+%Y-%m-%d %H:%M:%S'`
    date=`date +%Y%m%d`

    histFile="$TIMESTAMP_HISTFILE.$date"
    read x cmd <<< `history 1`
    if [ -r "$histFile" ]; then
        if [ "$TIMESTAMP_HIST_DUP" = 0 ]; then
            read x y lastCmd <<< `tail -n 1 "$histFile"`
            trimCmd=`trim <<< "$cmd"`
            trimLastCmd=`trim <<< "$lastCmd"`
            if [ "$trimLastCmd" = "$trimCmd" ]; then
                return
            fi
        fi
    fi

    echo "[$dateTime $USER `getUserIP`] $cmd" >> "$histFile"
}

shopt -s histappend
export PROMPT_COMMAND='timestampHistory'

export PS4='+$LINENO '
export HISTSIZE=9999999
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;31m\]@\[\033[01;36m\]\h\[\033[01;31m\]:\[\e[33m\]\w\[\e[0m\]\$ '
export EDITOR=vi

# echo to stderr
echoe()
{
    echo -e "$@" 1>&2
}

bce()
{
	echo "scale=3; $@" | bc
}

# pkill with "-9"
pkillf()
{
    if [ $# -lt 1 ]; then
        echoe "No process name specify."
        return
    fi

    psgrep "$*" | awk '{print $2}' | xargs kill -9
}

delnonsvn()
{
    dir="$1"
    svn st "$dir" | `which grep` -F '?' | xargs rm -rf
}

delbackup()
{
    dir="$1"
    find $dir -name "*~" -type f | xargs rm -rf
}

alias ls='ls --color'
alias ll='ls -l'
alias smth='screen ssh ahei0802@bbs.newsmth.net'
alias e='emacsclient -n'
alias cp='cp -r'
alias grep='grep --color'
alias mysql='mysql --pager=more --prompt="\u@\h:\d>\_"'
alias watch='watch -n 1 -d'
alias cman='man -M /usr/share/man/zh_CN/'
alias utol="tr '[A-Z]' '[a-z]'"
alias trim='sed -r "s/^[[:space:]]*|[[:space:]]*$//g"'
alias TRIM="trim | tr '[A-Z]' '[a-z]'"
alias jip='java -javaagent:/usr/share/jip/profile/profile.jar -Dprofile.properties=/usr/share/jip/profile/profile.properties'
alias emerge='emerge -u'
alias psgrep='ps -ef | grep'
alias nsgrep='netstat -nap | grep'
alias scp='scp -r'
alias lld='ls -l | grep "^d"'
alias llf='ls -l | grep "^-"'
alias ssh='ssh -o StrictHostKeyChecking=no'
alias apt-get='apt-get -y'
alias aptg='apt-get'
alias aptc='apt-cache'
alias aptf='apt-file'

ulimit -c unlimited

# less color configure
# blue
export LESS_TERMCAP_mb=$'\E[01;34m'
# red
export LESS_TERMCAP_md=$'\E[01;31m'
# magenta
export LESS_TERMCAP_me=$'\E[01;35m'
# write
export LESS_TERMCAP_se=$'\E[0m'
# yellow
export LESS_TERMCAP_so=$'\E[01;44;33m'
# cyan
export LESS_TERMCAP_ue=$'\E[01;36m'
# green
export LESS_TERMCAP_us=$'\E[01;32m'

# keychain
applyKeychain()
{
    keychain ~/.ssh/id_rsa
    . ~/.keychain/"$HOSTNAME"-sh
}
applyKeychain
