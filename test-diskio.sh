#!/bin/bash

# Time-stamp: <2012-03-05 17:07:01 Monday by taoshanwen>

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
    -p TEMP_PREFIX
        Specify prefix of mktemp command.
    -v  Output version info.
    -h  Output this help.
EOF

    exit "$code"
}

bs=1024
count=1048576

while getopts ":hvb:c:i:p:" OPT; do
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

        p)
            tempPrefix="$OPTARG"
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

[ -n "$tempPrefix" ] && opts="-p $tempPrefix"
tempFile=`mktemp $opts`
tempFile2=`mktemp $opts`

echo "Test with bs=$bs count=$count ..."

echo "Test write performance ..."
dd if=/dev/zero of="$tempFile" bs="$bs" count="$count"

echo "Test read performance ..."
dd if="$tempFile" of=/dev/null bs="$bs" count="$count"

echo "Test read and write performance ..."
dd if="$tempFile" of="$tempFile2" bs="$bs" count="$count"

rm -rf "$tempFile" "$tempFile2"
