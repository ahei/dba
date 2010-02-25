#!/usr/bin/env bash

# Time-stamp: <2010-02-25 10:01:58 Thursday by ahei>

# @version 1.0
# @author ahei

bin=`dirname "$0"`
bin=`cd "$bin"; pwd`

svn up "${bin}" "$@"
"${bin}"/install.sh
