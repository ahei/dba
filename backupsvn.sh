#!/bin/sh

# Time-stamp: <03/29/2009 21:28:38 星期日 by ahei>

readonly PROGRAM_NAME="backupsvn.sh"
readonly PROGRAM_VERSION="1.0"

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
usage: ${PROGRAM_NAME} [OPTIONS] <REPOS_PATH> [<DST_FILE>]

<DST_FILE> default is <REPOS_PATH>.
 
Options:
    -i [<INSTALL_DIR>]
        Install this shell script to your machine, INSTALL_DIR default is /usr/bin.
    -v  Output version info.
    -h  Output this help.
EOF
    
    exit "$code"
}

while getopts ":i:hv" OPT; do
    case "$OPT" in            
        v)
            version
            ;;

        h)
            usage 0
            ;;

        i)
            install "$OPTARG"
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
