#!/bin/sh

# Time-stamp: <03/24/2009 14:08:38 星期二 by ahei>

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
"$bin"/backupsvn.sh -i
