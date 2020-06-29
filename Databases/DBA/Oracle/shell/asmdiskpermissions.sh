#!/usr/bin/sh

echo $1
if [ -e $1 ]
then
chown grid:oinstall $1
chmod 660 $1

ls -l $1

else 
echo "\nPlease enter valid disk name \n"
fi
