-- http://docs.oracle.com/cd/E11882_01/server.112/e17023/cli.htm#i1006660    -- section 6.8
-- refer to doc \\mbtafs\park_plaza\itd\common\Oracle\Documents\HCMS\migration_docs\adgdr\MBTA_PROD_DR_SETUP.txt

-- http://www.ritzyblogs.com/OraTalk/PostID/106/How-to-switchover-using-DGMGRL-broker-with-example


11.2 Data Guard Physical Standby Switchover Best Practices using the Broker [ID 1305019.1]

Assumptions:

Primary DB before Switchover : DatabaseA
Standby DB before Switchover : DatabaseB

Primary DB after Switchover : DatabaseB
Standby DB after Switchover : DatabaseA

**IMPORTANT**
-> Stop observer

dgmgrl -logfile observer.log sys/sssdp@emgcr "stop observer"

-> On Primary [DatabaseA]: Create a restore point.

create restore point before_dgmgrl  guarantee flashback database;

-> Both Primary and Standby: Open two putty sessions with tail -f of alert logs.
-> connect to DGMGRL command line 
$ dgmgrl
DGMGRL> connect sys/passwrd@emgcr
-> check the primary database by issuing the "show database verbose 'emgcr';"
-> check the standby database by issuing the "show database verbose 'emgcrdr';"
-> issue the switchover command "switchover to 'emgcrdr';"

-> If standby doesnt comeup do below.
On Standby :
Shutdown immediate;
startup nomount;
alter database mount standby database;
alter database recover managed standby database using current logfile disconnect from session; --check standby controlfile consistant with primary
alter database recover managed standby database cancel;
alter database open read only;
alter database recover managed standby database using current logfile disconnect from session;

-> issue "show configuration" in DG broker command line.
-> optinal, do a log switch in primary and see if it is shipped to standby.
-> start observer again
-> Swap the archive log deletin policy.

*****VERY IMPORTANT*** IF this is not performed danger of filling up space in ASM***** 
Change the rman archive log deletion policy.

On current primary [DatabaseB]: CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY BACKED UP 2 TIMES TO 'SBT_TAPE';
On current standby [DatabaseA]: CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;
 
*** IMP *** This has to be done if the standby database is going to be in primary role for too long, if it stays as 
primary for too long and the policy is not changed,  archivelogs will not be deleted on current standby [DatabaseA] and will fill up the FRA area causing log shipping problems.




Swithcover Issues.
--------------------

DGMGRL Switchover fails with ORA-3113 using Oracle Restart [ID 1299085.1]


NAME=ora.emgcrdr.db
ACL=owner:grid:--x,pgrp:asmdba:--x,other::r--,group:oinstall:r-x,user:oracle:rwx


crsctl modify resource ora.emgcr.db -attr "ACL='owner:grid:rwx,pgrp:dba:rwx,other::r--,user:oracle:rwx'" -f -i
crsctl modify resource ora.emgcrdr.db -attr "ACL='owner:grid:rwx,pgrp:dba:rwx,other::r--,user:oracle:rwx'" -f -i



DGMGRL> switchover to emgcrdr;
Performing switchover NOW, please wait...
New primary database "emgcrdr" is opening...
Operation requires shutdown of instance "emgcr" on database "emgcr"
Shutting down instance "emgcr"...
ORA-01109: database not open

Database dismounted.
ORACLE instance shut down.
Operation requires startup of instance "emgcr" on database "emgcr"
Starting instance "emgcr"...
ORA-01031: insufficient privileges

Warning: You are no longer connected to ORACLE.

Please complete the following steps to finish switchover:
        start up instance "emgcr" of database "emgcr"

		
		
		Standby became primary SCN: 234624986








