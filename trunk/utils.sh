#!/bin/sh

# Time-stamp: <03/29/2009 21:05:22 星期日 by ahei>

export PS4='+$LINENO '
export HISTSIZE=9999999
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007\n"'
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;31m\]@\[\033[01;36m\]\h\[\033[01;31m\]:\[\e[33m\]\w\[\e[0m\]\$ '

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
    svn st "$dir" | grep '?' | xargs rm -rf
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
