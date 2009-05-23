#!/bin/bash

# Time-stamp: <05/23/2009 17:35:25 星期六 by ahei>

readonly PROGRAM_NAME="install.sh"
readonly PROGRAM_VERSION="1.0"

HOSTS_FILE=/etc/hosts

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

. "$bin"/common.sh

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
usage: ${PROGRAM_NAME} [OPTIONS] [<INSTALL_DIR>]

INSTALL_DIR default is /usr/bin.

Options:
    -p <PROFILE>
        PROFILE defualt is /etc/profile.
    -v  Output version info.
    -h  Output this help.
EOF

    exit "$code"
}

writeToFile()
{
    line="$1"
    dst="$2"

    if ! grep -qFx "${line}" "$dst"; then
        printf "\n$line" >> "$dst"
    fi
}

profile="/etc/profile"

while getopts ":hvp:" OPT; do
    case "$OPT" in            
        p)
            profile="$OPTARG"
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
                echoe "Option \`-${OPTARG}' need argument.\n"
                usage 0
        esac
        ;;

        ?)
            echoe "Invalid option \`-${OPTARG}'.\n"
            usage
            ;;
    esac
done

shift $((OPTIND - 1))

installDir="/usr/bin"
if [ $# -ge 1 ]; then
    installDir="$1"
fi

ln -sf "${bin}"/.mostrc ~
ln -sf "${bin}"/.toprc ~

writeToFile ". $bin/utils.sh" "$profile"
writeToFile ". $bin/history.sh" "$profile"
writeToFile ". $bin/temp/temp.sh" "$profile"

IFS=$'\n'
for i in `cat "$bin"/temp/temp-hosts`; do
    writeToFile "$i" "$HOSTS_FILE"
done
    
cp "$bin"/common.sh "$installDir"

"$bin"/svntag -i "$installDir"
"$bin"/remote.sh -i "$installDir"
"$bin"/backupsvn.sh -i "$installDir"
