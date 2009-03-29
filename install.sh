#!/bin/sh

# Time-stamp: <03/29/2009 15:29:04 星期日 by ahei>

install()
{
    src="$1"
    dst="$2"

    line=". $src"
    if ! grep -qFx "${line}" "$dst"; then
        printf "\n$line" >> "$dst"
    fi
}

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

ln -sf "${bin}"/.mostrc ~
ln -sf "${bin}"/.toprc ~

install "$bin/utils.sh" "/etc/profile"
install "$bin/temp/temp.sh" "/etc/profile"

"$bin"/svntag -i
"$bin"/remote.sh -i
"$bin"/backupsvn.sh -i
