#!/bin/bash
bin=$1
if [ ! -n "$bin" ]; then
echo "Useage: eg. sh get_rpm_name.sh ifconfig"
exit;
fi
path=`which $bin`
rpmname=`rpm -qf $path`
echo $rpmname
