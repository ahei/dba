#!/bin/bash

# Time-stamp: <08/03/2009 09:59:00 星期一 by ahei>

# @file test-diskio.sh
# @version 1.0
# @author ahei

readonly PROGRAM_NAME="test-diskio.sh"
readonly PROGRAM_VERSION="1.0.0"

home=`dirname "$0"`
home=`cd "$home" && pwd`

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

# echo to stdout
echoo()
{
    printf "$*\n"
}

# echo to stderr
echoe()
{
    printf "$*\n" 1>&2
}

bs=1024
count=1048576

while getopts ":hvb:c:" OPT; do
    case "$OPT" in
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
