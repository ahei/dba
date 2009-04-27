#!/bin/sh

# Time-stamp: <04/27/2009 11:42:35 星期一 by ahei>

export TIMESTAMP_HISTDIR=~/.history
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
