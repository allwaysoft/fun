Unix General
——————————————————————–
External Links
——————————————————————–
http://www.oracle-base.com/articles/misc/UNIXForDBAs.php –Uhnix commands for DBA’s
http://www.rocket99.com/unix/unix32.html –Basic shell programming
http://www.uic.edu/depts/accc/software/unixgeneral/vi101.html –Vi
http://www.cyberciti.biz/faq/unix-creating-symbolic-link-ln-command/ –Symbolic links

High memory and swap usage on UNIX.
——————————————————————–

http://h30499.www3.hp.com/t5/Databases/High-memory-usage-on-HPux-11iv3-with-oracle-10/td-p/5375777#.UBGY4aBf3l4

UNIX stats
——————————————————————–

http://docs.oracle.com/cd/E11882_01/server.112/e16638/autostat.htm

http://www.thegeekstuff.com/2010/04/unix-tar-command-examples/

If scp is not working below link might be of help to debug the problem.
——————————————————————–

http://h30499.www3.hp.com/t5/System-Administration/ssh-connect-to-host-port-22-Connection-refused/td-p/4649971#.UBKbhqBf3l4

http://stackoverflow.com/questions/3253789/how-to-get-top-output-in-solaris-machine

——————————————————————–
VI Editor
——————————————————————–
vi file_name: opens file in view mode

->pressing i here will take it to insert mode. In insert mode changes can be made to a file.
While in insert mode if you have to delete a text, u have to hit esc to get out of inert mode and type x, this will delete
the letter at the cursor. At this point after deleting the required text type i again to enter in to insert mode
and start typing.

If you want to copy a file and paste to other file. open first file copy the text and do :e second_file_name and then in the same session the second file opens and we can paste it there.
When you are in viewing mode, below are few helpful commands.
G to go to the end of the file. when opened in view mode.
1G Will take you to the beginning of the file. Likewise 50G will take to 50th line of the file.
dd to delete a line
dG If you’re in the first line of the file and have to delete the whole content of the file
:1,$d If you’re anywhere in the file and have to delete the whole content of the file
yy to copy a line
0 go to the beginning of the line
$ go to the end of the line
yw copy a word. place the cursor at the beginning of the word to copy a word
y$ copy text from the cursor point to the end of the line.
p paste a copied
u undo previous command, any cut copy or paste or…
shift+j merge two lines. Go to end of 1st line and enter this cmd to move the next line to this line.

CTRL-f Scroll forward one screen
CTRL-b Scroll back one screen
CTRL-u Scroll up half a screen
CTRL-d Scroll down half a screen

/foo searches for a string foo in the file.
n search for next occurrence
N search for previous occurrence

:s/search_sting/replace_sting search and replace in that line
:%s/search_sting/replace_sting search globally in the file
:s/search_sting/replace_sting/g replace globally in the file

:%s/nov10/\&month_year/g
to replace the nov10 with &month_year all occurrences in the file we use above command.
the %s in the above command searches for the string globally in the file.
the \ is escape character for the special character in the replace string the &.
the g at the end is used to replace globally in the file.

:%s/(ctrl-v)(ctrl-m)//g
Important!! ñ press (Ctrl-v) (Ctrl-m) combination to enter ^M character, dont use ì^î and M.

:set ignorecase use this command before issuing the above command to ignore the case of the search sting in the file.

——————————————————————–
UNIX VERSION
——————————————————————–
uname -a
getconf KERNEL_BITS –32 or 64 bits
who -r –gives the run-level of unix machine.
/usr/contrib/bin/machinfo –gives the machine info
/usr/sbin/swapinfo -a

——————————————————————–
UNIX Kernal parameters values
——————————————————————–
/usr/sbin/kctune

——————————————————————–
UNIX software installed
——————————————————————–
swlist -l patch
show_patches

——————————————————————–
IP
——————————————————————–
netstat -in
ifconfig -a                   gets all the ips, a machine is listening on. Once all the ip s are know. Use nslookup to know all the names of the host. nslookup to get the list of machines participating in scan.

——————————————————————–
UNIX stats
——————————————————————–
CPU sar, vmstat, mpstat, iostat
Memory sar, vmstat
Disk sar, iostat
Network netstat
psrinfo -pv gives physical and virtaul CPU info
prtconf | grep -i cpu will give CPUs
prtconf | grep Mem gives the total physical memory on the machine
prtdiag -v | grep Memory
vmstat gives memory and swap info on the machine

check Free physical Memory:
——————————————————————–
top (if available)
sar -r 5 10
–Free Memory=freemen*8 (pagesize=8k)
vmstat 5 10
–Free Memory = free

For swap:
——————————————————————–
# swap -s
# swap -l

http://docs.oracle.com/cd/E23824_01/html/821-1459/fsswap-52195.html

TOP
——————————————————————–
prstat equivalent to top

——————————————————————–
Directory commands
——————————————————————–
ls -d */ displays only directories
ls -d .*/ displays hidden directories
ls -al lists hidden files
mv file.txt /tmp
mv file1 file2 rename a file from file1 to file2
cd $HOME takes to the home directory of the the user
df for all the mount points and their usage on server
du -sk * gives the actual size of the directories under your current directory. Shows KB
chmod -R 775 mydir gives permissions to directory and all its sub directories
cp -r /home/hope/files/* /home/hope/backup ->This command copies all the directories and sub directories under …/files to …/backup
smh command is to for GUI of unix server. Create user in unix, it is a utility to create users and assign groups to users. This utility creates the user, creates the .profile file of the user under the directory /home/oracle.

——————————————————————–
ZIP Commands
——————————————————————–
unzip package.zip -d $ORACLE_HOME -> Where oracle home is the location where the unzipped files go to.
gzip -c filename > /loc-of-file/filename2.Z -> Gzip file
gzip -dc apache_1.3.19.tar.gz|tar xvf – ->gzip directoires
/opt/java6/bin or /usr/sbin or /usr/bin -> Look for jar at this location.
/opt/java6/bin/jar ñxvf filename.zip -> Using jar to unzip huge files

——————————————————————–
HP-UX admin console in web
——————————————————————–
/usr/sbin/sam
/usr/sbin/kcweb -F

——————————————————————–
crontab
——————————————————————–
crontab -l username –should be done as root user, to see crontab entries of other users

——————————————————————–
Set default Oracle Home for User
——————————————————————–
How to set ORACLE_HOME and ORACLE_SID in UNIX for oracle user. For every user there will be a directory with the name of the user under /home directory so..

go to /home/oracle and here you should find .profile(baurne or bash) file. Open it with vi and then add the below lines there.

# Set up the Oracle Home:
ORACLE_HOME=/apps/app/oracle/oracle/product/10.2.0/client_1 — Home of Oracle
export ORACLE_HOME

# Set up the Oracle SID:
ORACLE_SID=hordmo — Default sid, this will be the default when we log in to unix.
export ORACLE_SID

Save the file and it should be set for the next time you log in.

——————————————————————–
Setting PATH in Unix
——————————————————————–
export PATH=$PATH:<your additions seperated with colons>
export PATH=$PATH:/apps/app/oracle/product/10.2.0/client_1/bin ->Where /apps/app/oracle/product/10.2.0/client_1/bin is the location of the sqlplus. After this is done, we can run sqlplus from any where.
env | sort gives all the set environment variables for that user.

——————————————————————–
How to use auto fill from previous commands type like bash if bash is not used
——————————————————————–
Press Esc key and the combination of keys k and j are used to get the previous commands
k is for the most recent command
j is for move between the commands returned by pressing k
a is for exiting out of the bash mode in to the normal $ mode

——————————————————————–
pstack command in UNIX
——————————————————————–
pstack <process id>

——————————————————————–
CHECK the RAM size on the machine
——————————————————————–
# /usr/contrib/bin/machinfo | grep -i Memory

——————————————————————–
USERS AND INFORMATION ABOUT USERS
——————————————————————–
vi /etc/passwd This file says about the home of a user in the first line.
set shows all the parameters set to a particular user
finger all the current loings for that user

——————————————————————–
Memory usage by process in UNIX
——————————————————————–
–For all processes:
UNIX95= ps -e -o pid,sz,pcpu,ruser,args

–For a single process (in this case PID 4161)
UNIX95= ps -p 26309 -o pid,sz,pcpu,ruser,args

–Top 5 highest cpu user
UNIX95= ps -e -o pcpu,pid | sort -n -r |grep -v “%CPU”|head -5

UNIX95= ps -e -o vsz=kbytes -o ruser -o pid,args=Command-Line | sort -rnk1 | grep -v kbytes >> mem_test.log

ipcs -a

——————————————————————–
write the output of a command to file in unix
——————————————————————–
command >> file_name.ext

——————————————————————–
view last 100 lines of a file
——————————————————————–
tail -100 file_name.ext
tail-100f file_name.ext -> This will show the content of a file as it changes and doesn’t get out of it. This will help in viewing log files when during an installation.

——————————————————————–
find command
——————————————————————–
find . -mtime +60 -exec rm -rf {} \; –to delete old files older than 60 days60 is the number of days. The “.” in the command can be replaced with “/” to search for a file from the root directory.
find /u01/app/oracle/diag/rdbms/hrprd/hrprd/trace/*.trc -mtime +15 -print -exec rm {} \;
find /u01/app/oracle/diag/rdbms/hrprd/hrprd/trace/cdmp* -mtime +15 -print -exec rm {} \; — used this to remove directories with name cdmp…
find . -name file_name.ext –will search for the file in the current and all the sub directories of the current directory.
find . -type d -name “zinstall” –find directory
find . \( -name file1.txt -o -name file2.txt \) –to look for more than one file
find /u01 \( -name *.log -o -name *.trc -o -name *.trm \) >>/tmp/houst.txt
find /u01 -name *.log >/tmp/house.txt
find . *.gz -mtime +130 -print -exec mv {} ../statspack_archive \; –move older files to a different directory.

——————————————————————–
grep command
——————————————————————–
grep -r “modules” . –searching for word modules in all the files of current directory
grep -l “modules” . –skip outpout and just get file names
grep -l “mod.*” ./log* –find word starting with mod, in files starting with log, in current directory

——————————————————————–
tar command
——————————————————————–
tar cvf archive_name.tar dirname/ –to tar, here dirname is the director TO BE tar’d
tar cvzf archive_name.tar.gz dirname/ — not working on VMs
tar cvfj archive_name.tar.gz dirname/
tar cvf – my_dir | gzip -c > my_dir.tar.gz –tar and gzip in one command
tar xvf archive_name.tar –to untar, this will untar to the location where it was tard from.
for backing up, you use
[/backups]# tar -cvf /dev/rmt/tx5 /home/*.*
& then you restore using
[/backups]# tar -xvf /dev/rmt/tx5 *
the files will be restored to /home & not /backups, but

if you backup using
[/home]# tar -cvf /dev/rmt/tx5 *.*
& then restore using
[/backups]# tar -xvf /dev/rmt/tx5 *
the files will be restored to /backups

——————————————————————–
mailx on UNIX
——————————————————————–
echo “email body would be this text” | mailx -s “testing testing” “kpabba@xxxxx.com”

——————————————————————–
FILE PERMISSIONS AND TYPES
——————————————————————–
What does the ‘c’ permission define for permissions, ‘crw-rw-rw-’?

‘c’ represents a character device e.g. a serial port or a terminal – note these process data in bits.
‘b’ represents a block device e.g. hard drive, cdrom etc.. these process data in blocks or bytes.
‘l’ represents a symbolic (soft) link as in a Windows shortcut
‘d’ represents directory
‘-’ represents a file

drwxrwxrwt 20 root root 8192 May 21 13:35 tmp
“t” in the above permissions represent a sticky bit and it means only owner or root can delete the directory but no one else.

chmod +t tmp
chmod -t tmp

——————————————————————–
SCP
——————————————————————–
scp -pr file_name user_name@server_name:<path>/.
scp -r directory_name user_name@server_name:<path>/.

——————————————————————–
SHELL
——————————————————————–
–diff between if and test in unix

http://compgroups.net/comp.unix.programmer/difference-between-test-and/53459

– if with AND operator

http://www.unix.com/shell-programming-scripting/39286-help-regarding-error-message-test-command-parameter-not-valid.html

– AND operator and OR operator

http://stackoverflow.com/questions/6583126/problem-with-logical-operator-in-bash-script

$@ = stores all the arguments as a single string
$* = stores all the arguments in a list of string
$# = stores the number of arguments
$? has the return code of previous command. 0 is success/true and 1 is false/failure
IF conditionals
Comparisons: -eq equal to
-ne not equal to
-lt less than
-le less than or equal to
-gt greater than
-ge greater than or equal to
File Operations: -s file exists and is not empty
-f file exists and is not a directory
-d directory exists
-x file is executable
-w file is writable
-r file is readable
shift is a shell builtin that operates on the positional parameters. Each time you invoke shift, it “shifts” all the positional parameters down by one. $2 becomes $1, $3 becomes $2, $4 becomes $3, and so on.

Try this: shift is used with while as the $# condition in the while becomes smaller and smaller as the shift is executed and finally the while loop will be executed

BBH BBH BBH BBH----------------------------
--Fid panels and lookups using a tag55
    starview1@starwb1q:/opt/apps/starweb01/tpe/dynamic/dat> find . -name "*.htm" -exec grep -w "ACORPACTION"  {} \; -print
    starview1@starwb1q:/opt/apps/starweb01/tpe/dynamic/lookup> find . -name "*.htm" -exec grep -w "ACORPACTION"  {} \; -print
  
    starview1@starwb1q:/opt/apps/starweb01/tpe/dynamic/dat> find . -name "*.htm" -exec grep -w "ACORPACTION"  {} \; -print | grep .htm
    starview1@starwb1q:/opt/apps/starweb01/tpe/dynamic/lookup> find . -name "*.htm" -exec grep -w "ACORPACTION"  {} \; -print | grep .htm
  
    starview1@starwb1q:/opt/apps/starweb01/tpe/modules> find . -name "*.cfg" -exec grep -w "ACORPACTION"  {} \; -print
  
  
    find . -name \*.dat -exec grep -w "OUT"  {} /dev/null \;    --This will look for the word OUT in all the data files in that directory and output the whole line along with the file name where it found that
    find . -name \*.dat | xargs grep -w "OUT" {}  /dev/null \;   --Same as above but a different way of doing it. This could be FASTER
  
  
    find . -name "*.htm" -exec grep -w "HOLDINGSRPT"  {} \; -print | grep .htm
    find . -name "*.htm" -exec grep -w "TDHOLDINGSRPT"  {} \; -print | grep .htm

--*************PERL Project*****
 Below two are to execute a command returned by find or ls
 find /opt/apps/staradp01/scripts -name '*.pl' |grep -v bkup|grep -v test|xargs grep GSperl |cut -d":" -f 1|uniq|xargs perl -c
 for f in ./*.pl ; do perl -c ${f} ; done

 Below is to get perl modules installed
/opt/apps/local/GSperl/bin/perl -MFile::Find=find -MFile::Spec::Functions -Tlwe \
'find { wanted => sub { print canonpath $_ if /\.pm\z/ }, no_chdir => 1 }, @INC'

--************* 

 
--Find profiles used by ddr staging tables.
 ...tpe> find . ! -type d -print0 | xargs -0 grep I_DDRACPRCRPTMTH  | awk 'BEGIN { FS="^" } { print $2 }' | sort -u
 OR
 ...> grep -r --exclude-dir=.svn  -i ddr_lot_view (the -r and --exclude-dir options work only with grep only on Linux)
 explanation of above:
 "find ." is looking for everything under current directory, inclusing sub directories.
 "! -type d" this is exclude the search from contents of directory names. Logically, directory names are just names and no content, so exclude them
 "-print0" Fill spaces in the file names with special characters so that the following grep will not have problem with file names with spaces
 "xargs" this is like an iterator which issues grep command on each output produced by 'find' earlier. So, for every file name returned by find, grep is executed
 "-0" this says that spaces in file name are replaced with a special character
 "grep I_DDRACPRCRPTMTH" word I_DDRACPRCRPTMTH is being searched in the file name returned by the find
 "| awk 'BEGIN { FS="^" } { print $2 }' | sort -u" this is specific to doing a substring of the results provided by grep. Use this when required to beautify greps output
 
 --same as above but we can for multiple strings at once
 export EVT='I_DDRACPRCRPTMTH I_DDRACDIVINCLYFDM'
 for event in $EVT ; do echo $event && find . ! -type d -print0 | xargs -0 grep "$event"  | awk 'BEGIN { FS="^" } { print " "$2 }' | sort -u ; done

--Find Schedules used by profiles
 tpe\dynamic\schedule\schedules> grep -wl "DDR_BBH_DIVIDEND_INCOME_LFYD" *

 --same as above but we can for multiple strings at once
 export EVT='DDR_BBH_DIVIDEND_INCOME_LFYD DDR_BBH_DIVIDEND_INCOME_LFYDM DDR_BBH_DIVIDEND_INCOME_LFYDM DDR_BBH_DIVIDEND_INCOME_PFYD DDR_BBH_DIVIDEND_INCOME_PFYDM DDR_BBH_Fund_Admin_TB_Daily DDR-BBH-NAV-TRIAL-CL-SEC DDR-NAV-TrialBalance-Class-DailyM DDR-NAV-TrialBalance-Class-DailyMeta DDR-BBH-NAV-TRIAL-TF-SEC DDR-BBH-NAV-TRIAL-TF-SEC-Meta DDR-NAV-TrialBalance-TF-DailyM DDR-NAV-TrialBalance-TF-DailyMeta DDR_BBH_SHAREHOLDER_ACTIVITY_PD DDR-BBH-TD-2-SD-GL-LFYD DDR-BBH-TD-2-SD-GL-LFYDM DDR_BBH_DIVIDEND_PROJECTION DDR_BBH_PORTFOLIO_VALUATION_PD DDR_BBH_RLZD_GAIN_LOSS2_EXP'
 
 tpe\dynamic\schedule\schedules> for event in $EVT ; do echo $event && grep -wl "$event" * ;  done
 
--Below command is used to grep for a value in the log files which are at a particular path on MULTIPLE MACHINES
 pssh -i -A -H "$(for i in {1..40}; do echo apx${i}-starm ; done)" 'grep "info" /opt/apps/stareng/star/engines/*/logs/*'

grep -iR "insert\sinto\stradesdbo.trade" ./  --this will search for a sentence "insert into tradesdbo.trade" (it ignores case and mutiple spaces between words) in curent and all sub directories


Split a file based on a condition.    --http://superuser.com/questions/466363/how-to-split-a-text-file-into-multiple-text-files
$ gawk '{if(match($0, /DDL for Index (.+?)/, k)){name=k[1]}} {print >name".sql" }' tst1.sql  --This command splits the file based on a string "DDL for Index" below is an example of contents of tst1.txt 

mkdir out1 && for f in *sql ; do egrep  -v  '^-+-$' $f > out1/$f; done   --this command will remove any line with "---" from begin to end in all the scripts which end with "sql"
sed -i 's/;/;\n\//g' *    --replaces a ";" in the file with a ";" in one line and "/" in the next line
sed -i '3,$s/----*//g' *  --replaces a line with "---------" with nothing.


for f in *sql ; do if [ -f ../constraints/$f ]; then cat $f ../constraints/$f > ./tabcons/$f; else cp $f ./tabcons/; fi; done --This command will merge the files from different directories if the file                                exists in both the places, if the file doesn't exist, it just copies the first file to the destination directory.

ls -l | grep '^d' --List only directories.

Profile
--------
set current dir @ prompt, add this to profile. export PS1='$(whoami)@$(hostname):$(pwd)>'

SVN
------
svn co  http://badcvs1t.bbh.com:9595/star/trunk/web/combined_web_1.0/tpe/dynamic/dat ~/svn/star/trunk/web/combined_web_1.0/tpe/dynamic/dat/
svn co  http://badcvs1t.bbh.com:9595/star/trunk/sql/1.0/star/sql ~/svn/star/trunk/sql/1.0/star/sql/
svn update --Use this if the directory is alreayd setup using svn co and just want to update that directory from svn.