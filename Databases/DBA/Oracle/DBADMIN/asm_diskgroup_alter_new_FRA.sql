ALTER DISKGROUP DATA DROP DISK DATA_0000;
ALTER DISKGROUP DATA ADD DISK '/dev/rdisk/disk15' force;
ALTER DISKGROUP DATA DROP DISK DATA_0001;
ALTER DISKGROUP DATA ADD DISK '/dev/rdisk/disk17' force;
ALTER DISKGROUP DATA DROP DISK DATA_0002;
ALTER DISKGROUP DATA ADD DISK '/dev/rdisk/disk19' force;
ALTER DISKGROUP DATA DROP DISK DATA_0003;
ALTER DISKGROUP DATA ADD DISK '/dev/rdisk/disk21' force;



CREATE DISKGROUP FNPRDBDAT EXTERNAL REDUNDANCY
DISK
'/dev/rdisk/disk7',
'/dev/rdisk/disk9',
'/dev/rdisk/disk11',
'/dev/rdisk/disk13'
ATTRIBUTE 'au_size'='4M',
'compatible.asm' = '11.2.0.0.0', 
'compatible.rdbms' = '10.1.0.0.0';

CREATE DISKGROUP FNPRDBFRA EXTERNAL REDUNDANCY
DISK
'/dev/rdisk/disk15',
'/dev/rdisk/disk17',
'/dev/rdisk/disk19',
'/dev/rdisk/disk21',
'/dev/rdisk/disk23'
ATTRIBUTE 'au_size'='4M',
'compatible.asm' = '11.2.0.0.0', 
'compatible.rdbms' = '10.1.0.0.0';

CREATE DISKGROUP FNDM1ADAT EXTERNAL REDUNDANCY
DISK
'/dev/rdisk/disk79',
'/dev/rdisk/disk81',
'/dev/rdisk/disk83',
'/dev/rdisk/disk85',
'/dev/rdisk/disk87',
'/dev/rdisk/disk89'
ATTRIBUTE 'au_size'='4M',
'compatible.asm' = '11.2.0.0.0', 
'compatible.rdbms' = '10.1.0.0.0';


CREATE DISKGROUP FNDM1AFRA EXTERNAL REDUNDANCY
DISK
'/dev/rdisk/disk91',
'/dev/rdisk/disk93',
'/dev/rdisk/disk95',
'/dev/rdisk/disk97'
ATTRIBUTE 'au_size'='4M',
'compatible.asm' = '11.2.0.0.0', 
'compatible.rdbms' = '10.1.0.0.0';

-----------------------------------------------
CREATE DISKGROUP FAPADAT EXTERNAL REDUNDANCY
DISK
'/dev/rdisk/disk7',
'/dev/rdisk/disk9',
'/dev/rdisk/disk11',
'/dev/rdisk/disk13'
ATTRIBUTE 'au_size'='4M',
'compatible.asm' = '11.2.0.0.0', 
'compatible.rdbms' = '10.1.0.0.0';

CREATE DISKGROUP FAPAFRA EXTERNAL REDUNDANCY
DISK
'/dev/rdisk/disk15',
'/dev/rdisk/disk17',
'/dev/rdisk/disk19',
'/dev/rdisk/disk21'
ATTRIBUTE 'au_size'='4M',
'compatible.asm' = '11.2.0.0.0', 
'compatible.rdbms' = '10.1.0.0.0';

CREATE DISKGROUP FADAFRA EXTERNAL REDUNDANCY
DISK
'/dev/rdisk/disk23',
'/dev/rdisk/disk25',
'/dev/rdisk/disk27',
'/dev/rdisk/disk29'
ATTRIBUTE 'au_size'='4M',
'compatible.asm' = '11.2.0.0.0', 
'compatible.rdbms' = '10.1.0.0.0';
-----------------------------------------------

---------------------------------------------------------------------------
DROP DISKGROUP DATA INCLUDING CONTENTS; -- Warning: All the data will be lost, if this doesn't work, follow below two steps.

DROP DISKGROUP TSTDATA INCLUDING CONTENTS;
alter diskgroup TSTDATA dismount force;
drop diskgroup TSTDATA force including contents;

DROP DISKGROUP FNPRDBDAT INCLUDING CONTENTS;
alter diskgroup FNPRDBDAT dismount force;
drop diskgroup FNPRDBDAT force including contents;

alter diskgroup drdata dismount force;
drop diskgroup drdata force including contents;

alter diskgroup fra dismount force;
drop diskgroup fra force including contents;
		  
/*
alter system set asm_diskstring='/dev/rdisk/d*' scope=both;     -- do this as sysasm

*/

-----------------------------
remove a disk from diskgroup
-----------------------------
ALTER DISKGROUP DATADR DROP DISK DATADR_0004;

--------------------------
add a disk to a diskgroup
--------------------------
ALTER DISKGROUP FRADR ADD DISK '/dev/rdisk/disk21';