#!/bin/sh

# Time-stamp: <03/24/2009 14:05:08 星期二 by ahei>

readonly PROGRAM_NAME="backupsvn.sh"
readonly PROGRAM_VERSION="1.0"

usage()
{
    cat << EOF
usage: ${PROGRAM_NAME} [OPTIONS] <REPOS_PATH> [<DST_FILE>]

<DST_FILE> default is <REPOS_PATH>.
 
Options:
    -i  Install this shell script to your machine.
    -v  Output version info.
    -h  Output this help.
EOF
    
    exit
}

version()
{
    echo "${PROGRAM_NAME} ${PROGRAM_VERSION}"
    exit
}

install()
{
    cp "$0" "${installDir}"
    ret=$?
    if [ "${ret}" = 0 ]; then
        echo "Install finished."
    fi
    exit "${ret}"
}

installDir="/usr/bin"

while getopts ":ihv" OPT; do
    case "$OPT" in            
        v)
            version
            ;;

        h)
            usage
            ;;

        i)
            install
            ;;

        :)
        case "${OPTARG}" in
            ?)
                echo -e "Option \`-${OPTARG}' need argument.\n"
                usage
        esac
        ;;

        ?)
            echo -e "Invalid option \`-${OPTARG}'.\n"
            usage
            ;;
    esac
done

shift $((OPTIND - 1))

if [ "$#" -lt 1 ]; then
    echo -e "No svn repository specify.\n"
    usage 1
fi

svnRepos="$1"
if [ ! -d "$svnRepos" ]; then
    echo -e "\`$svnRepos' is a file, not a directory."
    usage 1
fi

dstFile="$svnRepos"
if [ "$#" -ge 2 ]; then
    dstFile="$2"
fi

cd `dirname "$svnRepository"` &&                            \
    rm -rf "$svnRepos".bak &&                               \
    svnadmin hotcopy "$svnRepos" "$svnRepos".bak &&         \
    mv "$dstFile".tgz "$dstFile".tgz.bak > /dev/null 2>&1 ; \
    tar czf "$dstFile".tgz "$svnRepos".bak
