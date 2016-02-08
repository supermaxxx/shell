#!/bin/bash
echo -n "Please enter command: "
read cmd
if [ -n ${cmd} ]; then
  bin_path=$(which ${cmd} 2>/dev/null)
  if [ $? -eq 0 ];then
    rpm -qf ${bin_path}
  else
    echo "The command \"${cmd}\" is not exist!"
  fi
fi


## result:
#[root@localhost ~]# sh use_command_to_find_rpmname.sh
#Please enter command: abc
#The command "abc" is not exist!
#[root@localhost ~]# sh use_command_to_find_rpmname.sh
#Please enter command: ifconfig
#net-tools-2.0-0.17.20131004git.el7.x86_64
