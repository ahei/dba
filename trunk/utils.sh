#!/bin/bash

# Time-stamp: <06/16/2009 10:36:16 星期二 by ahei>

export PS4='+$LINENO '
export HISTSIZE=9999999
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;31m\]@\[\033[01;36m\]\h\[\033[01;31m\]:\[\e[33m\]\w\[\e[0m\]\$ '
export EDITOR=vi

alias ls='ls --color'
alias ll='ls -l'
alias smth='luit -encoding gb18030 ssh bbs.newsmth.net'
alias e='emacsclient -n'
alias cp='cp -r'
alias grep='grep --color'
alias mysql='mysql --pager=more --prompt="\u@\h:\d>\_"'
alias watch='watch -n 1 -d'
alias eman='man -M /usr/share/man/'
alias cman='man -M /usr/share/man/zh_CN/'
alias utol="tr '[A-Z]' '[a-z]'"
alias trim='sed -r "s/^[[:space:]]*|[[:space:]]*$//g"'
alias TRIM="trim | tr '[A-Z]' '[a-z]'"
alias jip='java -javaagent:/usr/share/jip/profile/profile.jar -Dprofile.properties=/usr/share/jip/profile/profile.properties'
alias emerge='emerge -u'
alias psgrep='ps -ef | grep'
alias nsgrep='netstat -nap | grep'
alias scp='scp -r -o StrictHostKeyChecking=no'
alias lld='ls -l | grep "^d"'
alias llf='ls -l | grep "^-"'
alias ssh='ssh -o StrictHostKeyChecking=no'

alias apt-get='apt-get -y'
alias aptg='apt-get'
alias aptc='apt-cache'
alias aptf='apt-file'

alias svni='svn info'
alias svns='svn st'
alias svnh='svn help'
alias svndi='svn di'
alias svna='svn add'
alias svnm='svn mkdir'
alias svnu='svn up'
alias svnc='svn cleanup'
alias svnrm='svn rm'
alias svnr='svn revert'
svnt()
{
    file="$1"

    touch "$file"
    svn add "$file"
}
svnd()
{
    file="$1"

    svn revert "$file"
    rm -rf "$file"
}

alias path="echo -e ${PATH//:/'\n'}"
alias cpath="echo -e ${CLASSPATH//:/'\n'}"

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
    psgrep "$*"
}

delnonsvn()
{
    dir="$1"
    svn st "$dir" | `which grep` -F '?' | xargs rm -rf
}

delbackup()
{
    dir="$1"
    find $dir '(' -name "*~" -o -name "#*#" ')' -type f | xargs rm -rf
}

genproxy()
{
    ip="$1"
    user="$2"
    
    ssh "$ip" -l "$user" -D 8888 -N -f
}

# keychain
applyKeychain()
{
    key=~/.ssh/id_rsa
    if [ -r "$key" ]; then
        keychain "$key" -q --ignore-missing --noask && \
        . ~/.keychain/"$HOSTNAME"-sh
    fi
}
applyKeychain
