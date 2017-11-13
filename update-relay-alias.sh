#!/bin/bash -l

# Time-stamp: <2017-11-13 14:31:41 Monday by ahei>

# @file update-relay-alias.sh
# @version 1.0
# @author ahei

readonly PROGRAM_NAME="update-relay-alias.sh"
readonly PROGRAM_VERSION="1.0.0"

home=`cd $(dirname "$0") && pwd`

. "$home"/common.sh

usage()
{
    local code=1
    local redirect
    
    if [ $# -gt 0 ]; then
        code="$1"
    fi

    if [ "$code" != 0 ]; then
        redirect="1>&2"
    fi

    eval cat "$redirect" << EOF
usage: ${PROGRAM_NAME} [OPTIONS]

Options:
    -p <PROFILE>
        PROFILE defualt is /etc/profile.
    -v  Output version info.
    -h  Output this help.
EOF

    exit "$code"
}

update()
{
    local file=$1

    if [ ! -f "$file" ]; then
        return
    fi

    local full
    
    for i in $(awk '$1 == "." && NF == 2{print $2}' "$file"); do
        full=$i
        if [[ "${full:0:1}" != "/" ]]; then
            full=$(joinPath $(dirname "$file") "$i")
        fi
        update "$full"
    done

    shopt -s expand_aliases

    local oldIfs="$IFS"
    IFS=$'\n'
    
    local key
    for i in $(grep -vE "^[[:space:]]*#" "$file" |
                      awk -F= '$1 && $2 && $2 ~ /^[^ ]+$/ {printf "alias %s=\"hd %s\"\n", $1, $2}'); do
        key=$(echo "$i" | awk -F"[ =]" '{print $2}')
        if ! type "$key" &>/dev/null && [ "$key" ]; then
            writeToFile "$i" "$file".alias
        fi
    done

    if [ ! -f "$file.alias" ]; then
        return
    fi
    
    IFS="$oldIfs"
    writeToFile ". $file.alias 2>/dev/null" "$profile"
}

options=":hvp:"
eval set -- $(getopt -o "$options" -- "$@")
while getopts "$options" OPT; do
    case "$OPT" in
        p)
            profile="$OPTARG"
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

update /etc/remoterc
update ~/.remoterc
