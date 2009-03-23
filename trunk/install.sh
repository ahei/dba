#!/bin/sh

# Time-stamp: <03/23/2009 15:43:47 星期一 by ahei>

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

ln -sf "${bin}"/.mostrc ~
ln -sf "${bin}"/.toprc ~

line=". ${bin}/utils.sh"
if ! grep -qFx "${line}" /etc/profile; then
    printf "\n. ${bin}/utils.sh" >> /etc/profile
fi

"$bin"/svntag -i
"$bin"/remote.sh -i
