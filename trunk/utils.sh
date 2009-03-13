#!/bin/sh

# Time-stamp: <03/10/2009 17:56:24 星期二 by ahei>

export PAGER='/usr/bin/most -s'
export BROWSER='/usr/bin/most -s'
export PS4='+$LINENO '
export HISTSIZE=9999999
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007\n"'
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h:\[\e[33m\]\w\[\e[0m\]\$ '

bce()
{
	bc <<< "scale=3; $@"
}

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
