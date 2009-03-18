#!/bin/sh

# Time-stamp: <03/18/2009 15:54:41 星期三 by ahei>

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

ln -sf "${bin}"/.mostrc ~
ln -sf "${bin}"/.toprc ~

printf "\n. ${bin}/utils.sh" >> /etc/profile
