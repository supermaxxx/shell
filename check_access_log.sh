:'
现有web服务的访问日志webaccess.log，如下：
200 123.190.216.51 - shanghai.baixing.com [03/Mar/2013:02:59:59 +0800] "GET /menpiao/a250632202.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" 9175 384 54231
200 123.190.216.52 - shanghai.baixing.com [03/Mar/2013:03:59:59 +0800] "GET /menpiao/a250632202.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" 9175 384 54232
200 1.1.0.1 - shanghai.baixing.com [03/Mar/2013:03:57:59 +0800] "GET /menpiao/a250632201.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)" 9175 384 101
200 1.1.0.2 - shanghai.baixing.com [03/Mar/2013:03:57:59 +0800] "GET /menpiao/a250632201.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)" 9175 384 102
301 123.190.216.51 - shanghai.baixing.com [03/Mar/2013:03:59:59 +0800] "GET /menpiao/a250632202.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" 9175 384 54234
200 1.2.0.1 - shanghai.baixing.com [03/Mar/2013:03:57:59 +0800] "GET /menpiao/a250632201.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; Googlebot/2.0; +http://www.baidu.com/search/spider.html)" 9175 384 201
301 123.190.216.53 - shanghai.baixing.com [01/Apr/2013:03:59:59 +0800] "GET /menpiao/a250632202.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" 9175 384 54233
200 1.2.0.2 - shanghai.baixing.com [01/Apr/2013:03:57:59 +0800] "GET /menpiao/a250632201.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; Googlebot/2.0; +http://www.baidu.com/search/spider.html)" 9175 384 202
404 1.2.0.2 - shanghai.baixing.com [01/Apr/2013:03:57:59 +0800] "GET /menpiao/a250632201.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; Googlebot/2.0; +http://www.baidu.com/search/spider.html)" 9175 384 202
200 1.1.0.3 - shanghai.baixing.com [01/Apr/2013:03:57:59 +0800] "GET /menpiao/a250632201.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)" 9175 384 103
301 123.190.216.51 - shanghai.baixing.com [11/Nov/2013:03:59:59 +0800] "GET /menpiao/a250632202.html HTTP/1.1" "http://shanghai.baixing.com/menpiao/" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" 9175 384 54234
...
现需要从中分别提取所有包含“Googlebot”和“Baiduspider”，且非404打头的行，
分别保存到以访问日期分割的文件中并压缩，如googlebot.2013-03-03.log.bz2和baiduspider.2013-03-03.log.bz2。
请用bash shell，并以最优的方式实现这段脚本。
'

#!/bin/bash
# author: wangyucheng

access_log="webaccess.log"

function month() {
  input=$1
  d=$(date -d "$input"  +%Y-%m-%d)
  echo $d
}

function e2d() {
  input=$1
  if [ $input ];then
    date=$(echo $input | awk -F "/" '{print $1,$2,$3}')
    echo $date | while read a b c; do
      echo $(month "$b $a $c")
    done
  fi
}

function write_log() {
  file=$1"."$2".log"
  echo "$3" >> $file
}

function make_log() {
  cat $access_log |while read line
  do
    #head
    head=$(echo $line|awk '{print $1}')
    #date
    date1=$(echo $line |grep -oE '[0-9]{2}/[a-zA-Z]{3}/[0-9]{4}')
    date2=$(e2d $date1)    #01/Mar/2013 => 2013-03-01
    #from
    from_Baiduspider=$(echo $line|grep 'Baiduspider')
    from_Googlebot=$(echo $line|grep 'Googlebot')
    #handle
    if [[ $head -ne 404 ]] && [[ $from_Baiduspider ]] && [[ $date2 ]];then
      write_log "baiduspider" $date2 "$line"
    elif [[ $head -ne 404 ]] && [[ $from_Googlebot ]] && [[ $date2 ]];then
      write_log "googlebot" $date2 "$line"
    fi
  done
}

function pre() {
  find . |egrep 'baiduspider|googlebot'*'log|log.bz2' | xargs -exec rm -rf {} \;
}

function make_bz2() {
  for f in $(find . | egrep 'baiduspider|googlebot');do
    bzip2 -z $f
    echo $f" has been compressed."
  done
}

##run
pre
make_log
make_bz2
