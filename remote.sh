#!/bin/sh

# Time-stamp: <03/24/2009 14:24:41 星期二 by ahei>

readonly PROGRAM_NAME="remote.sh"
readonly PROGRAM_VERSION="1.0"

usage()
{
    cat << EOF
usage: ${PROGRAM_NAME} [OPTIONS] <HOST> <COMMAND>
       ${PROGRAM_NAME} [OPTIONS] -H <HOST> <COMMAND>
       ${PROGRAM_NAME} [OPTIONS] -c <COMMAND> <HOSTS>
       ${PROGRAM_NAME} [OPTIONS] -f <HOSTS_FILE> <COMMAND>
       ${PROGRAM_NAME} [OPTIONS] -F <FILE> [-d <DST_FILE>] <HOSTS>

Options:
    -H <HOST>
        Add host.
    -f <HOSTS_FILE>
        Add the hosts file.
    -F <FILE>
        Add the file to copy.
    -d <DST_FILE>
        Set the destination file.
    -l <LOGIN_NAME>
        Specifies the user to log in as on the remote machine.
    -n  Do not really execute command, only print command to execute.
    -q  Quiet, do not write process info to standard output.
    -s  When execute command on one machine, stop execute command on others.
    -g  Execute command foreground.
    -i  Install this shell script to your machine.
    -v  Output version info.
    -h  Output this help.
EOF

    code=0
    if [ $# -gt 0 ]; then
        code="$1"
    fi

    exit "$code"
}

version()
{
    echo "${PROGRAM_NAME} ${PROGRAM_VERSION}"
    exit
}

executeCommand()
{
    _command="$1"
    _isExecute="$2"
    _isQuiet="$3"
    _isStop="$4"
    
    [ "$_isQuiet" != 1 ] && echo "Executing command \`${_command}' ..."
    if [ "${_isExecute}" != "0" ]; then
        eval "${_command}"
        if [ $? != 0 ]; then
            echo "Execute command \`${_command}' failed."
            if [ "$_isStop" = 1 ]; then
                exit 1
            fi
        fi
    fi
}

install()
{
    cp "$0" "${installDir}"
    ret=$?
    if [ "${ret}" = 0 ]; then
        echo "Install remote.sh finished."
    fi
    exit "${ret}"
}

installDir="/usr/bin"
isExecute=1
IFS=$'\n'

while getopts ":hvH:f:F:d:l:nqc:si" OPT; do
    case "$OPT" in
        H)
            hosts="$hosts\n$OPTARG"
            ;;

        f)
            if [ ! -r "$OPTARG" ]; then
                echo "Can not read file \`$OPTARG'."
                exit 1
            fi
            
            hosts="$hosts\n`cat $OPTARG`"
            ;;

        F)
            if [ ! -r "$OPTARG" ]; then
                echo "Can not read file \`$OPTARG'."
                exit 1
            fi

            isCopy=1
            files="$files $OPTARG"
            ;;

        d)
            dstFile="$OPTARG"
            ;;
            
        l)
            user="$OPTARG"
            ;;

        n)
            isExecute=0
            ;;

        q)
            isQuiet=1
            ;;

        c)
            command="$OPTARG"
            ;;

        s)
            isStop=1
            ;;

        g)
            isForeground=1
            ;;

        i)
            install
            ;;
        
        v)
            version
            ;;

        h)
            usage
            ;;

        :)
        case "${OPTARG}" in
            ?)
                echo -e "Option \`-${OPTARG}' need argument.\n"
                usage 1
        esac
        ;;

        ?)
            echo -e "Invalid option \`-${OPTARG}'.\n"
            usage 1
            ;;
    esac
done

shift $((OPTIND - 1))

if [ -z "$isCopy" ]; then
    if [ -z "$hosts" ]; then
        if [ "$#" -lt 1 ]; then
            echo -e "No host and command specify.\n"
            usage 1
        elif [ "$#" -lt 2 ]; then
            echo -e "No command specify.\n"
            usage 1
        fi

        if [ -n "$command" ]; then
            for i in $@; do
                hosts="$hosts\n$i"
            done
        else
            hosts="$hosts\n$1"
            shift
            command="$@"
        fi
    else
        if [ "$#" -lt 1 ]; then
            echo -e "No command specify.\n"
            usage 1
        fi

        if [ -n "$command" ]; then
            for i in $@; do
                hosts="$hosts\n$i"
            done
        else
            command="$@"
        fi
    fi

    for i in `printf "$hosts"`; do
        [ -n "$user" ] && login=" -l $user"
        executeCommand "ssh $i$login \"$command\" 2>&1 | sed \"s/^/$i: /\" &" "$isExecute" "$isQuiet" "$isStop"
    done

    wait
    
    exit
fi

IFS=
for i in $@; do
    hosts="$hosts\n$i"
done

IFS=$'\n'
for i in `printf "$hosts"`; do
    if [ -z "$user" ]; then
        host="$i"
    else
        host="$user@$i"
    fi

    executeCommand "scp -r $files $host:$dstFile 2>&1 | sed \"s/^/$i: /\" &" "$isExecute" "$isQuiet" "$isStop"
done

wait
