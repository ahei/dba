#!/bin/sh

# Time-stamp: <08/24/2009 09:57:23 Monday by ahei>

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
    if [[ "$TERM" = "eterm" || "$TERM" = "eterm-color" ]]; then
        echo
    else
        echo -e "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007"
    fi
    
    history -a

    if [ ! -d "$TIMESTAMP_HISTDIR" ]; then
        [ -e "$TIMESTAMP_HISTDIR" ] && mv "$TIMESTAMP_HISTDIR" "$TIMESTAMP_HISTDIR".bak
        mkdir "$TIMESTAMP_HISTDIR" -p
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

    echo "[$dateTime `getUserIP`] $USER:${TIMESTAMP_HIST_PWD:-$PWD}$ $cmd" >> "$histFile"
    TIMESTAMP_HIST_PWD="$PWD"
}

shopt -s histappend
export PROMPT_COMMAND='timestampHistory'
