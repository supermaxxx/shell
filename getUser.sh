#!/bin/sh
echo -n "Please enter the user: "
read user
cat /etc/passwd|awk -F ":" -v var=$user '{if($1==var) {print "user:"$1"  uid:"$3"  home:"$6"";exit;}}'
