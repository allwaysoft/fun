Set heading off
Set feedback off
Set pagesize 0
Set termout off
Set trimout on
Set trimspool on
Set recsep off
Set linesize 50000
Column d noprint new_value date_
Column u noprint new_value user_
Spool c:\temp\tmp
Select "Select "||owner||"."||table_name||" , "||"count(*) from "||owner||"."||table_name ||";",
to_char(sysdate, ‘YYYYMMDDHH24MISS’) d, user u
from all_tables
where owner not in (‘SYS’, ‘SYSTEM’)
order by table_name;