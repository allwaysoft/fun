
SET VERIFY OFF 
SET serveroutput on size 1000000

accept from_which_database prompt 'Insert from which database:'
accept to_which_database prompt 'Insert to which database:'

declare

v_cnt      NUMBER;
v_cnt_&to_which_database NUMBER;
v_cnt_&from_which_database NUMBER;
record_count_mismatch exception;

begin

dbms_output.put_line(chr(9));

for i in
(
SELECT 
  BDB_BASE_CODE,
  BDB_BASE_DESCRIPTION,
  BDB_SHORT_DESC,
  BDB_USER,
  BDB_LAST_UPD_DATE,
  BDB_SYS_DEFINED_FLAG,
  BDB_BASE_TYPE--,
  --BDB__IU__CREATE_DATE,
  --BDB__IU__CREATE_USER,
  --BDB__IU__UPDATE_DATE,
  --BDB__IU__UPDATE_USER
FROM da.PYBDBASE@&from_which_database 
where to_date(bdb_last_upd_date,'dd-mon-yy') < to_date('30-dec-99','dd-mon-yy') 
and to_date(bdb_last_upd_date,'dd-mon-yy') > to_date('24-feb-05','dd-mon-yy') 
) loop
INSERT INTO da.PYBDBASE@&to_which_database
(  
  BDB_BASE_CODE,
  BDB_BASE_DESCRIPTION,
  BDB_SHORT_DESC,
  BDB_USER,
  BDB_LAST_UPD_DATE,
  BDB_SYS_DEFINED_FLAG,
  BDB_BASE_TYPE--,
  --BDB__IU__CREATE_DATE,
  --BDB__IU__CREATE_USER,
  --BDB__IU__UPDATE_DATE,
  --BDB__IU__UPDATE_USER
)
values
(
i.   BDB_BASE_CODE,
i.   BDB_BASE_DESCRIPTION,
i.   BDB_SHORT_DESC,
i.   BDB_USER,
i.   BDB_LAST_UPD_DATE,
i.   BDB_SYS_DEFINED_FLAG,
i.   BDB_BASE_TYPE--,
--i.   --BDB__IU__CREATE_DATE,
--i.   --BDB__IU__CREATE_USER,
--i.   --BDB__IU__UPDATE_DATE,
--i.   --BDB__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYBDBASE@&to_which_database
where to_date(bdb_last_upd_date,'dd-mon-yy') < to_date('30-dec-99','dd-mon-yy') 
and to_date(bdb_last_upd_date,'dd-mon-yy') > to_date('24-feb-05','dd-mon-yy') ;
dbms_output.put_line ('Inserted '||v_cnt||' records into PYBDBASE table.');
select count(1) into v_cnt_&to_which_database from da.PYBDBASE@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYBDBASE@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYBDBASE table, check and commit.');
else
dbms_output.put_line ('Number of records in &from_which_database does not match with &to_which_database for PYCOMPAYPRD table.');
Raise record_count_mismatch;
end if;
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in &from_which_database and &to_which_database for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYBDBASE@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);
end;
/ 