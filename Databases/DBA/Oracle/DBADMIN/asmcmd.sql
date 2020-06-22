http://download.oracle.com/docs/cd/B19306_01/server.102/b14215/asm_util.htm

select name, free_mb from v$asm_diskgroup

select GROUP_NUMBER, DISK_NUMBER, MODE_STATUS, STATE, NAME, PATH from v$asm_disk order by group_number, disk_number

SELECT name, type, total_mb, free_mb, required_mirror_free_mb, 
usable_file_mb FROM V$ASM_DISKGROUP
order by free_mb

select d.name disk_name,g.name group_name,d.path,d.total_mb,d.free_mb
from v$asm_disk d, v$asm_diskgroup g
where d.group_number = g.group_number (+)

select dg.name group_name, t.name template_name, dg.type, t.redundancy, t.stripe
from v$asm_diskgroup dg, v$asm_template t

--asmcmd is the command line utility for asm
--asmca is gui to add or configure disks


-- ASM File Creattion Date and size  
select to_char(f.creation_date,'dd-mon-yyyy'), a.name, bytes, redundancy, a.group_number, a.file_number
 from v$asm_file f, v$asm_alias a 
 where a.name in ('STATSPACK.269.783346017')  --Use FILE NAME HERE not the DISK GROUP NAME
 and    a.group_number = f.group_number 
 and    a.file_number = f.file_number;


-- Below sql gives the files present in a diskgroup 
select adg.name group_name, aa.name file_name, af.type, af.creation_date date_created,  bytes/1024/1024 Size_MB
from    v$asm_alias aa 
      , v$asm_diskgroup adg
      , v$asm_file af
where adg.group_number = aa.group_number
    and aa.group_number = af.group_number 
    and aa.file_number = af.file_number
    and adg.name in ('HRPAYDATA')
    --and (upper(aa.name) like '%USER%' OR upper(aa.name) like '%TEMP%' OR upper(aa.name) like '%UNDO%' OR upper(aa.name) like '%SYSTEM%' OR upper(aa.name) like '%SYSAUX%')        
order by date_created desc 

Current.257.767015107
Current.383.767015107

TEMP
UNDO
USERS
SYSTEM

select * from V$ASM_DISKGROUP_STAT
 
select * from v$asm_diskgroup
 
select * from v$asm_alias
 
select * from v$asm_operation

select group_number from v$asm_file group by group_number


 
 where upper(name) like
 
 
 select * from dba_users
 
 
 
 select * from v$asm_disk_stat
 
 
--============ Drop ASM DISKS ============= 
 
select * from v$asm_disk_stat where name like '%HRSTG%'

select * from v$asm_disk

select * from v$asm_diskgroup

select * from v$asm_operation

select * from v$asm
   
select * from v$asm_disk_stat order by group_number, disk_number

select group_number, disk_number, name, path from v$asm_disk order by group_number, disk_number


alter diskgroup hrstgfra drop disk HRSTGFRA_0006;
alter diskgroup hrstgfra drop disk HRSTGFRA_0005; 
alter diskgroup hrdevfra drop disk HRDEVFRA_0005;
alter diskgroup hrdevfra drop disk HRDEVFRA_0006;
alter diskgroup hrtstfra drop disk HRTSTFRA_0005;
alter diskgroup hrtstfra drop disk HRTSTFRA_0006;



