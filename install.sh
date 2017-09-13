#!/bin/bash

# Time-stamp: <2017-09-13 10:56:04 Wednesday by ahei>

readonly PROGRAM_NAME="install.sh"
readonly PROGRAM_VERSION="1.0"

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
    -C  Do not update submodules.
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

if [ "$USER" = root ]; then
    profile="/etc/profile"
else
    profile=~/.bashrc
fi

while getopts ":hvp:C" OPT; do
    case "$OPT" in            
        p)
            profile="$OPTARG"
            ;;

        C)
            updateSub=0
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

if [ "$updateSub" != 0 ]; then
    git submodule update --init --recursive
    (cd remote-tools && git pull origin master)
fi
$home/remote-tools/install.sh

ln -sf "${home}"/.mostrc ~
ln -sf "${home}"/.toprc ~
ln -sf "${home}"/.screenrc ~
ln -sf "${home}"/.xmodmap ~
ln -sf "${home}"/.tmux.conf ~
# cp "${home}"/ssh-config ~/.ssh/config
# chmod 600 ~/.ssh/config
cp "${home}"/.gdbinit ~

writeToFile ". $home/utils.sh" $profile
writeToFile ". $home/history.sh" $profile
writeToFile "export PATH=$home:"'$PATH' $profile

terminalFile=`which gnome-terminal 2>/dev/null`
if [ $? = 0 ]; then
    ln -sf "$terminalFile" "$home/terminal"
fi

mkdir -p ~/.config/terminator/
ln -sf "${home}"/terminator-config ~/.config/terminator/config
