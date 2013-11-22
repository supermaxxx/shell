#!/bin/sh
echo -n "Please enter the user: "
read user
cat /etc/passwd|awk -F ":" -v var=$user '{if($1==var) {print "user:"$1"  uid:"$3"  home:"$6"";exit;}}'
#awk应该是做了个for循环，从下面这句注释掉额语句的结果可知。
#cat /etc/passwd|awk -F ":" -v var=$user '{if($1==var) {print "user:"$1"  uid:"$3"  home:"$6"";exit;} else {print ""$1" is not matched."}}'
