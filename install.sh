#!/bin/bash

# Time-stamp: <2012-03-06 18:34:06 Tuesday by taoshanwen>

readonly PROGRAM_NAME="install.sh"
readonly PROGRAM_VERSION="1.0"

HOSTS_FILE=/etc/hosts

home=`dirname "$0"`
home=`cd "$home"; pwd`

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

ln -sf "${home}"/.mostrc ~
ln -sf "${home}"/.toprc ~
ln -sf "${home}"/.screenrc ~

writeToFile ". $home/utils.sh" "$profile"
writeToFile ". $home/history.sh" "$profile"

cp "$home"/common.sh "$installDir"
cp "$home"/temp/luke "$installDir"
cp "$home"/temp/lukeall-*.jar "$installDir"

"$home"/svntag -i "$installDir"
"$home"/remote.sh -i "$installDir"
"$home"/backupsvn.sh -i "$installDir"
"$home"/test-diskio.sh -i "$installDir"
"$home"/syncsvn.sh -i "$installDir"
cp baidu baike google cmb json "$installDir"

terminalFile=`which gnome-terminal 2>/dev/null`                                                                                                              
if [ $? = 0 ]; then
    ln -sf "$terminalFile" /usr/bin/terminal
fi
