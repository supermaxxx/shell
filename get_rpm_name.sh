#!/bin/bash
#通过命令查找所属rpm包
bin=$1
if [ ! -n "$bin" ]; then
echo "Useage: eg. sh get_rpm_name.sh ifconfig"
exit;
fi
path=`which $bin`
rpmname=`rpm -qf $path`
echo $rpmname
