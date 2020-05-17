#!/bin/sh
user=$1
echo $user
/usr/bin/clear
tot=0
for j in `UNIX95= ps -e -o ruser|sort -u`
do
user=$j
t=0
for i in `UNIX95= ps -e -o sz=Kbytes -o ruser -o pid,args=Command-Line | sort -rnk1|grep -v Kbytes|grep "$user"|awk '{ print $1 }'`
do
t=`expr $t + $i`
done
echo "\n $user memory usage is $t KB "
tot=`expr $tot + $t`
done
echo "\n Total Memory by all users is $tot KB"


echo "Swapinfo :"
/usr/sbin/swapinfo
echo "\n"

