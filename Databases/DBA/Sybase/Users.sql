@set autocommit on
go
begin
declare @new_user varchar(50),
        @new_full_name varchar(100)
        select @new_user = 'DKrall'
        select @new_full_name = 'Daniel Krall'USE master
EXEC sp_addlogin @new_user,'','','us_english',@new_full_name,null,6,null

USE hinet

EXEC sp_adduser @new_user,@new_user,'read_only'
--USE hiperf
--EXEC sp_adduser @new_user,@new_user,'read_only'
end
go

--sp_displaylogin 'DKrall' --Server level
--select * from sysusers where name like '%DKrall%' --DB Level
--select * from sysalternates --DB Level
--sp_helpuser 'DKrall' Jason Samuel
/*
select @@servername 'Server', db_name() 'Database', 'user:' 'Type', t1.suid, t1.name 'dbuser', t2.name 'ServerLogin' -- Find a db user tied to a specific login.
from sysusers t1, master..syslogins t2 
where t2.suid=t1.suid
and t2.name = 'DKrall'
union 
select @@servername, db_name(), 'alias:' 'Type', t1.suid, ' ' 'dbuser', t2.name 
from sysalternates t1, master..syslogins t2 
where t2.suid=t1.suid
and t2.name = 'DKrall' 
order by 2 
*/
--sp_helptext 'acdsp_BP_ZeroCouponBondExport'--use hinet
--sp_dropuser DKrall
--drop login JSamuel