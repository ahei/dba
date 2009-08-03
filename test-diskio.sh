#!/bin/bash

# Time-stamp: <08/03/2009 10:10:43 星期一 by ahei>

# @file test-diskio.sh
# @version 1.0
# @author ahei

readonly PROGRAM_NAME="test-diskio.sh"
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
usage: ${PROGRAM_NAME} [OPTIONS]

Options:
    -b BS
        Specify bs.
    -c COUNT
        Specify count.
    -i [<INSTALL_DIR>]
        Install this shell script to your machine, INSTALL_DIR default is /usr/bin.
    -v  Output version info.
    -h  Output this help.
EOF

    exit "$code"
}

bs=1024
count=1048576

while getopts ":hvb:c:i:" OPT; do
    case "$OPT" in
        i)
            install "$OPTARG"
            ;;
        
        b)
            bs="$OPTARG"
            ;;
        
        c)
            count="$OPTARG"
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

tempFile=`mktemp`

echo "Test write performance ..."
dd if=/dev/zero of="$tempFile" bs="$bs" count="$count"

echo "Test read performance ..."
dd if="$tempFile" of=/dev/null bs="$bs" count="$count"

echo "Test read and write performance ..."
dd if="$tempFile" of=`mktemp` bs="$bs" count="$count"
