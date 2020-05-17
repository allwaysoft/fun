
-- FULL AVAILABLE TABLE SPACE

select tablespace_name , sum(bytes) bytes_total
from dba_data_files
group by tablespace_name ;

-- USED TABLE SPACE

select tablespace_name , sum (bytes) bytes_full
from dba_extents
group by tablespace_name 


select * from user_tablespaces

select * from dba_tablespaces 