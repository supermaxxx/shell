#!/bin/bash
echo -n "Please enter command: "
read cmd
if [ -n "$cmd" ]; then
binpath=`which $cmd`
echo "BIN_PATH: "$binpath
rpmname=`rpm -qf $binpath`
echo "RPM_NAME: "$rpmname
fi


## result:
# sh use_command_to_find_rpmname.sh
# Please enter command: df
# BIN_PATH: /usr/bin/df
# RPM_NAME: coreutils-8.22-11.el7.x86_64
