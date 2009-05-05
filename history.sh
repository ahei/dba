#!/bin/sh

# Time-stamp: <05/06/2009 01:02:30 星期三 by ahei>

export TIMESTAMP_HISTDIR=~/.history
export TIMESTAMP_HISTFILE="$TIMESTAMP_HISTDIR/.history_timestamp"
export TIMESTAMP_HIST_DUP=1
export TIMESTAMP_HIST_PWD

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

    dateTime=`date '+%F %A %T'`
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

    echo "[$dateTime $USER `getUserIP`] $cmd (wd: ${TIMESTAMP_HIST_PWD:-$PWD})" >> "$histFile"
    TIMESTAMP_HIST_PWD="$PWD"
}

shopt -s histappend
export PROMPT_COMMAND='timestampHistory'
