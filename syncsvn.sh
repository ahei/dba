#!/bin/bash

# Time-stamp: <08/21/2009 11:23:47 Friday by ahei>

# @file syncsvn.sh
# @version 1.0
# @author ahei

readonly PROGRAM_NAME="syncsvn.sh"
readonly PROGRAM_VERSION="1.0.0"

home=`dirname "$0"`
home=`cd "$home" && pwd`

. "$home"/common.sh

usage()
{
    code=1
    if [ $# -gt 0 ]; then
        code="$1"
    fi

    if [ "$code" != 0 ]; then
        redirect="1>&2"
    fi

    eval cat "$redirect" << EOF
usage: ${PROGRAM_NAME} SRC_DIR [DST_DIR] [OPTIONS]

DST_DIR default is "."

Options:
    -s SRC_START_REV
        Specify start revision of source directory.    
    -e SRC_END_REV
        Specify end revision of source directory.    
    -i [<INSTALL_DIR>]
        Install this shell script to your machine, INSTALL_DIR default is /usr/bin.
    -q  Quiet, do not write process info to standard output.
    -n  Do not really execute command, only print command to execute.
    -v  Output version info.
    -h  Output this help.
EOF

    exit "$code"
}

version()
{
    echoo "${PROGRAM_NAME} ${PROGRAM_VERSION}"
    exit
}

isExecute=1
isQuiet=0
isStop=1

dstDir="."

while getopts ":hvi:s:e:qn" OPT; do
    case "$OPT" in
        i)
            install "$OPTARG"
            ;;

        s)
            srcStartRev="$OPTARG"
            ;;

        e)
            srcEndRev="$OPTARG"
            ;;

        q)
            isQuiet=1
            ;;
            
        n)
            isExecute=0
            ;;

        v)
            version
            ;;

        h)
            usage 0
            ;;

        :)
            case "${OPTARG}" in
                i)
                    install
                    ;;
                
                ?)
                    echoe "Option \`-${OPTARG}' need argument.\n"
                    usage
            esac
            ;;

        ?)
            echoe "Invalid option \`-${OPTARG}'.\n"
            usage
            ;;
    esac
done

shift $((OPTIND - 1))

srcDir="$1"
[ -n "$2" ] && dstDir="$2"

ecArgs="$isExecute $isQuiet $isStop"

for ((i = srcStartRev; i <= srcEndRev; i++)); do
    log="$(svn log $srcDir -r$i | sed -n '4,$ p')"
    count=$(wc -l <<< "$log")
    let count--
    log=$(sed -n "1, $count p" <<< "$log")
    
    nums=$(sed -n "/^$/=" <<< "$log" | tac)
    no="$count"
    for num in $nums; do
        if [[ "$num" != "$no" ]]; then
            break
        fi

        let no--
    done

    log=$(sed -n "1, $no p" <<< "$log")
    
	echo "Log is \`$log'"

    log=${log//\`/\\\`}

	executeCommand "patch -d $dstDir -p0 < <(cd $srcDir && svn di -r$((i-1)):$i)" $ecArgs

    if grep -sq "'" <<< "$log"; then
        command="svn ci $dstDir -m \"$log\""
    else
        command="svn ci $dstDir -m '$log'"
    fi

    executeCommand "$command" $ecArgs

    echo
done
