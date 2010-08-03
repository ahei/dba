#!/bin/bash

# Time-stamp: <2010-08-03 09:52:58 Tuesday by taoshanwen>

. common.sh

export PS4='+$LINENO '
export HISTSIZE=9999999
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;31m\]@\[\033[01;36m\]\h\[\033[01;31m\]:\[\e[33m\]\w\[\e[0m\]\$ '
export EDITOR=vi
export LESS="-FXs"

alias ls='ls --color -N --show-control-chars'
alias ll='ls -l'
alias l=ll
alias smth='luit -encoding gb18030 ssh bbs.newsmth.net'
alias asmth='luit -encoding gb18030 ssh bbs.newsmth.net -lahei0802'
alias e='emacsclient -n'
alias ec='emacsclient -nc'
alias cp='cp -r'
alias grep='grep --color'
alias mysql='mysql --pager=more --prompt="\u@\h:\d>\_"'
alias watch='watch -n 1 -d'
alias man='LESS=-X man -M /usr/share/man/'
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
alias type='type -a'
alias md='mkdir'
alias suu='sudo su'
alias tial='tail'
alias mroe='more'

alias apt-get='apt-get -y'
alias aptg='apt-get'
alias aptgi='aptg install'
alias aptgr='aptg remove'
alias aptgp='aptg purge'
alias aptgud='aptg update'
alias aptgu='aptg upgrade'
alias aptc='apt-cache'
alias aptcs='aptc search'
alias aptf='apt-file'

alias svni='svn info'
alias svns='svn st'
alias svnh='svn help'
alias svndi='svn di'
alias svna='svn add'
alias svnm='svn mkdir'
alias svnmv='svn mv'
alias svnu='svn up'
alias svnc='svn cleanup'
alias svncp='svn cp'
alias svnci='svn ci -m'
alias svnrm='svn rm'
alias svnr='svn revert -R'
alias svnl='svn log'
alias ..='cd ..'
svnt()
{
    file="$@"

    touch $file
    svn add $file
}
svntx()
{
    file="$@"

    touch $file
    chmod +x $file
    svn add $file
}
svnd()
{
    file="$@"

    svn revert $file
    rm -rf $file
}

alias antc='ant clean'
alias antco='ant compile'
alias antd='ant dist'
alias antj='ant jar'
alias antt='ant test'

alias makec='make clean'
alias maket='make check'
alias makei='make install'

alias path="echo -e ${PATH//:/'\n'}"
alias cpath="echo -e ${CLASSPATH//:/'\n'}"

alias updaterc='. ~/.bashrc'
alias erc='vi ~/.bashrc'

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

delsvn()
{
    dir="$1"
    shift
    find $dir -name ".svn" -type d "$@" | xargs rm -rf
}

delbackup()
{
    dir="$1"
    shift 1
    find $dir "$@" '(' -name "*~" -o -name "#*#" ')' -type f | xargs rm -rf
}

genproxy()
{
    ip="$1"
    user="$2"
    
    ssh "$ip" -l "$user" -D 8888 -N -f
}

normalizePath()
{
    local path="$1"

    dir=$(dirname "$path")
    if [[ "$dir" != "." ]]; then
        path=$dir/$(basename "$path")
    else
        path=$(basename "$path")
    fi

    echo "$path"
}

addkey()
{
    key="$1"
    server="subkeys.pgp.net"
    (( $# > 1 )) && server="$2"

    gpg --keyserver subkeys.pgp.net --recv "$key"
    gpg --export --armor "$key" | apt-key add -
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

delaccount()
{
    user="$1"
    shift
    opts="$@"

    userdel $opts "$user"

    sed -r "/^[[:space:]]*$user[[:space:]]+ALL[[:space:]]*=[[:space:]]*\([[:space:]]*ALL[[:space:]]*\)[[:space:]]+ALL[[:space:]]*$/ d" -i".bak" /etc/sudoers
}

alias rcd='cd .. && cd - &>/dev/null'
alias emacs='emacs -nw --debug-init'
alias install-font='mkfontscale && mkfontdir && fc-cache'

if uname -a | grep gentoo >/dev/null; then
	command_not_found_handle()
    {
		echo "-bash: $1: command not found"
        e-file &>/dev/null
        if [[ "$?" != 127 ]]; then
		    e-file $1
        fi
	}
fi

# 删除除某个文件外的所有文件
rme()
{
    exclude="$1"
    shift
    rmArgs="$@"
    exclude=`sed -r "s#(.*)/#\1#g" <<< "$exclude"`
    find -mindepth 1 -maxdepth 1 ! -name "$exclude" | xargs rm $rmArgs
}

# 显示内存
mem()
{
    echo $(bce $(grep "MemTotal:" /proc/meminfo | awk '{print $2}')/1024/1024)G
}

terminalFile=`which gnome-terminal 2>/dev/null`
if [ $? = 0 ]; then
    ln -sf "$terminalFile" /usr/bin/terminal
fi
