#!/bin/bash
#通过命令查找所属rpm包
bin=$1
if [ ! -n "$bin" ]; then
echo "Useage: eg. sh get_rpm_name.sh ifconfig"
exit;
fi
path=`which $bin`
echo $path
rpmname=`rpm -qf $path`
echo $rpmname

#result
#[root@localhost ~]# sh get_rpm_name.sh ifconfig
#/sbin/ifconfig
#net-tools-1.60-110.el6_2.x86_64
