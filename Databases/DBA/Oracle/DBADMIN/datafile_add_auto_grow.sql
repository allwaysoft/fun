
-----------------------------
-- Below scripts generates script for auto extending ALL the data files in the database.
-----------------------------
spool runts.sql
 
select 
   'alter database datafile '||
   file_name||
   ' '||
   ' autoextend on;'
from 
   dba_data_files;
 
@runts

alter database datafile '/u14/oradata/nwcd/UDE07.dbf' autoextend on next 512M maxsize 8192M;


/u14/oradata/nwcd/UDE07.dbf    773    3 %    1000 Mb    34.1 Mb    966 Mb    64000    False        0    AVAILABLE    100    0

size 1024M autoextend on next 512M maxsize 8192M;

alter database datafile '/u11/oradata/nwcd/UDF17.DBF' autoextend on next 150M maxsize 8000M;
alter database datafile '/u11/oradata/nwcd/UDF18.DBF' autoextend on next 150M maxsize 8000M;
alter database datafile '/u11/oradata/nwcd/UDF19.dbf' autoextend on next 150M maxsize 8000M;
exit;

CREATE TEMPORARY TABLESPACE PSTEMP TEMPFILE 
  '+HRTSTDATA/hrtst/tempfile/pstemp01.dbf' SIZE 300M AUTOEXTEND OFF
TABLESPACE GROUP 

alter database tempfile  '+HRTSTDATA/hrtst/tempfile/pstemp01.dbf' autoextend on next 20M maxsize UNLIMITED 

alter database datafile 'E:\ORADATA\NWCD\UDB001.DBF' autoextend on next 150M maxsize 8000M;
alter database datafile 'E:\ORADATA\NWCD\UDB002.DBF' autoextend on next 150M maxsize 8000M;


ALTER TABLESPACE TEMP ADD TEMPFILE '/u12/oradata/nwcd/temp19.dbf' SIZE 1000M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;


alter tablespace user_index_g add datafile '/u10/oradata/nwcd/UIG20.dbf' size 1000M autoextend on next 150M maxsize 8000M;
alter tablespace user_index_g add datafile '/u10/oradata/nwcd/UIG21.dbf' size 1000M autoextend on next 150M maxsize 8000M;
alter tablespace user_index_g add datafile '/u10/oradata/nwcd/UIG22.dbf' size 1000M autoextend on next 150M maxsize 8000M;
alter tablespace user_index_g add datafile '/u10/oradata/nwcd/UIG23.dbf' size 1000M autoextend on next 150M maxsize 8000M;

alter tablespace user_data_b add datafile '/u12/oradata/nwcd/UDB111.dbf' size 1000M autoextend on next 100M maxsize 8000M;

alter database datafile '/u12/oradata/nwcd/UIF19.DBF' autoextend on next 150M maxsize 8000M;
alter database datafile '/u12/oradata/nwcd/UIF20.dbf' autoextend on next 150M maxsize 8000M;


alter tablespace user_data_b add datafile '/u12/oradata/nwcd/UDB112.dbf' size 1000M autoextend on next 300M maxsize 8000M;
alter tablespace user_data_b add datafile '/u12/oradata/nwcd/UDB113.dbf' size 1000M autoextend on next 300M maxsize 8000M;

alter tablespace user_data_d add datafile '/u12/oradata/nwcd/UDD96.dbf' size 1000M autoextend on next 300M maxsize 8000M;
alter tablespace user_data_d add datafile '/u12/oradata/nwcd/UDD97.dbf' size 1000M autoextend on next 300M maxsize 8000M;

alter database datafile '/u10/oradata/nwcd/UDG24.dbf' autoextend on next 150M maxsize 6000M;  -- this is max size 6000 to fit the file system.


alter database datafile '/u10/oradata/nwcd/UDD76.Dbf' autoextend on next 150M maxsize 8000M;
alter database datafile '/u10/oradata/nwcd/UDD77.Dbf' autoextend on next 150M maxsize 8000M;
alter database datafile '/u10/oradata/nwcd/UDD78.Dbf' autoextend on next 150M maxsize 8000M;

alter database datafile '/u10/oradata/nwcd/UDB90.Dbf' autoextend on next 300M maxsize 8000M;
alter database datafile '/u10/oradata/nwcd/UDB91.Dbf' autoextend on next 300M maxsize 8000M;
alter database datafile '/u10/oradata/nwcd/UDB92.Dbf' autoextend on next 300M maxsize 8000M;
alter database datafile '/u10/oradata/nwcd/UDB93.Dbf' autoextend on next 300M maxsize 8000M;