#!/bin/ksh
user=$1
echo $user
/usr/bin/clear
t=0
for i in `UNIX95= ps -e -o vsz=Kbytes -o ruser -o pid,args=Command-Line | sort -rnk1|grep -v Kbytes|grep "$user"|awk '{ print $1 }'`
do
t=`expr $t + $i`
done
echo "\n In total there is $t KB of memory claimed by user $user \n"

echo "Swapinfo :"
/usr/sbin/swapinfo
echo "\n"
