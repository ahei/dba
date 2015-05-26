#!/bin/bash

# Time-stamp: <2015-05-26 16:21:39 Tuesday by ahei>

. common.sh 2>/dev/null

export PS4='+$LINENO '
export HISTSIZE=9999999
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[01;31m\]@\[\033[01;36m\]\H\[\033[01;31m\] \[\e[33m\]\w\[\e[0m\] \$ '
export EDITOR=vi
export LESS="-FXs"

alias ls='ls --color=auto -N --show-control-chars'
alias ll='ls -l'
alias l=ll
alias smth='luit -encoding gb18030 ssh bbs.newsmth.net'
alias asmth='luit -encoding gb18030 ssh bbs.newsmth.net -lahei0802'
alias e='emacsclient -n'
alias ec='emacsclient -nc'
alias cp='cp -r'
alias grep='egrep --color'
alias fgrep='fgrep --color'
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
alias netgrep='netstat -nap | grep'
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
alias tccr='tcc -run'
function mcd()
{
    mkdir $1 -p && cd $1
}
alias tmuxr='tmux attach'

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
if [ "$(uname)" = "Darwin" ]; then
    alias aptcs='brew search'
    alias aptgi='brew install'
fi
if [ -f /etc/redhat-release ]; then
    alias aptcs='yum search'
    alias aptgi='yum install'
fi

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

alias gits='git status'
alias gitc='git clone'
alias gitl='git log --name-status'
alias gitp='git pull'
alias gitd='git diff'
alias gitb='git branch'
alias gitr='git checkout -- .'
alias gstash='git stash'
alias gstashp='git stash pop'
alias pushmaster='git push origin master'

pushc()
{
    local branch=$(gitb | fgrep '*' | cut -d " " -f2)

    git push origin $branch
}

mmaster()
{
    local branch=$(gitb | fgrep '*' | cut -d " " -f2)
    
    git checkout master && gitp && git checkout $branch && git merge master
}

alias aheif='git checkout ahei-feature'
alias aheim='git checkout xmpush-ahei 2>/dev/null || git checkout ahei'
alias master='git checkout master'
alias pushf='aheif && git push origin ahei-feature'
alias pushm='aheim && ( git push origin ahei 2>/dev/null || git push origin xmpush-ahei )'

if `colordiff -v &>/dev/null`; then
    alias diff=colordiff
    alias svndi='svn di --diff-cmd=colordiff'
fi

# url encode
alias url='python -c "import urllib; import sys; a=(len(sys.argv)>1 and sys.argv[1:] or sys.stdin); print urllib.quote(\"\".join(a), \":/@\")"'
# url decode
alias unurl='python -c "import urllib; import sys; a=(len(sys.argv)>1 and sys.argv[1:] or sys.stdin); print urllib.unquote(\"\".join(a))"'
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
alias maket='make test'
alias makei='make install'

alias mvnc='mvn clean'
alias mvnm='mvn compile'
alias mvnp='mvn package'
alias mvni='mvn install'
alias mvnt='mvn test -DskipTests=false'
alias mvnd='mvn deploy'
alias mvnmu='mvn compile -U'
alias mvnpu='mvn package -U'
alias mvniu='mvn install -U'
alias mvntu='mvn test -DskipTests=false -U'
alias mvndu='mvn deploy -U'

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

alias espeak='espeak 2>/dev/null'

bce()
{
    echo "scale=3; $@" | bc
}

ebce()
{
    espeak <<< "$@="
    echo "scale=3; $@" | bc | espeak
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
    find $dir "$@" '(' -name "*~" -o -name "#*#" ')' -type f -exec rm -rf '{}' ';'
}

genproxy()
{
    ip="$1"
    user="$2"

    ssh "$ip" -l "$user" -D 8888 -N -f
}

joinPath()
{
    local path="$1"
    local name="$2"

    if [[ "${path:-1:1}" = "/" ]]; then
        echo "${path}${name}"
    else
        echo "${path}/${name}"
    fi
}

baseName()
{
    local path="$1"

    if [[ "$path" = ".." ]] || [[ "$path" = "/" ]]; then
        echo "."
    else
        basename "$path"
    fi
}

dirName()
{
    local path="$1"

    if [[ "$path" = ".." ]]; then
        echo ".."
    else
        dirname "$path"
    fi
}

normalizePath()
{
    local path="$1"

    if [ -d "$path" ]; then
        echo "$(cd $path && pwd)"
        return
    fi

    local dir=$(dirname "$path")
    local basename=$(basename "$path")

    if [ -r "$dir" ]; then
        dir="$(cd $dir && pwd)"
    fi

    if [[ "$basename" != "." ]]; then
        path="$(joinPath $dir $basename)"
    else
        path="$dir"
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
alias install-font='mkfontscale && mkfontdir && fc-cache'

alias all='awk "{sum += $ 0}END{print sum}"'

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

y()
{
    local optInd=1
    local delay=.1
    local loop

    OPTIND=1

    while getopts ":d:l:" OPT; do
        case "$OPT" in
            d)
                delay="$OPTARG"
                let optInd+=2
                ;;

            l)
                loop="$OPTARG"
                let optInd+=2
                ;;
        esac
    done

    shift $((optInd - 1))

    local str="$@"
    local i=0

    [ "$str" ] || str=y

    while [ ! "$loop" ] || ((i < loop)); do
        echo "$str"
        sleep "$delay"

        let i++
    done
}

efind()
{
    local len="${#@}"

    if [ "$len" = 1 ]; then
        find -regextype posix-extended -regex "$@"
        return
    fi

    local dir="$1"

    shift
    find "$dir" -regextype posix-extended -regex "$@"
}

efindd()
{
    local len="${#@}"

    if [ "$len" = 1 ]; then
        find -regextype posix-extended -regex "$@"
        return
    fi

    find "${@:1:len-1}" -regextype posix-extended -regex "${@:len}"
}

# run java class
# usage: runjava -p PATH CLASS [ARGUMENTS]
# -p JAR_FILE | JAR_PATH
runjava()
{
    local optInd=1
    local paths
    local classpath

    OPTIND=1

    while getopts ":p:" OPT; do
        case "$OPT" in
            p)
                paths="$OPTARG"
                let optInd+=2
                ;;
        esac
    done

    if [ "$paths" ]; then
        for p in $paths; do
            # jar目录
            for jar in $(ls $p/*.jar 2>/dev/null); do
                    classpath=$classpath:$jar
            done
            classpath=$classpath:$p
        done
    fi

    shift $((optInd - 1))

    local command="java"
    if [ $1 == "--" ]; then
        shift
    fi

    if [ "$classpath" ]; then
        command="$command -cp ${classpath:1}"
    fi

    $command $@
}
