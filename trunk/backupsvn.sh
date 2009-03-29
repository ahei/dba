#!/bin/sh

# Time-stamp: <03/29/2009 11:39:41 星期日 by ahei>

readonly PROGRAM_NAME="backupsvn.sh"
readonly PROGRAM_VERSION="1.0"

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
usage: ${PROGRAM_NAME} [OPTIONS] <REPOS_PATH> [<DST_FILE>]

<DST_FILE> default is <REPOS_PATH>.
 
Options:
    -i  Install this shell script to your machine.
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
    echo -e "$@"
}

# echo to stderr
echoe()
{
    echo -e "$@" 1>&2
}

install()
{
    cp "$0" "${installDir}"
    ret=$?
    if [ "${ret}" = 0 ]; then
        echoo "Install backupsvn.sh finished."
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
            usage 0
            ;;

        i)
            install
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

if [ "$#" -lt 1 ]; then
    echoe "No svn repository specify.\n"
    usage
fi

svnRepos="$1"
if [ ! -d "$svnRepos" ]; then
    echoe "\`$svnRepos' is a file, not a directory."
    usage
fi

dstFile="$svnRepos"
if [ "$#" -ge 2 ]; then
    dstFile="$2"
fi

reposName=`basename "$svnRepos"`
cd `dirname "$svnRepos"` &&                                 \
    rm -rf "$svnRepos".bak &&                               \
    svnadmin hotcopy "$svnRepos" "$svnRepos".bak &&         \
    mv "$dstFile".tgz "$dstFile".tgz.bak > /dev/null 2>&1 ; \
    tar czf "$dstFile".tgz "$reposName".bak
