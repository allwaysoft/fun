
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
  BDH_CODE,
  BDH_VENDOR,
  BDH_CODE_TYPE,
  BDH_LONG_CODE,
  BDH_DESCRIPTION,
  BDH_ROW_CREATION_USER,
  BDH_ROW_CREATION_DATE,
  BDH_LAST_UPD_USER,
  BDH_LAST_UPD_DATE--,
  --BDH__IU__CREATE_DATE,
  --BDH__IU__CREATE_USER,
  --BDH__IU__UPDATE_DATE,
  --BDH__IU__UPDATE_USER
FROM da.HRBDADMINHEADER_EM@&from_which_database 
where bdh_code not like 'ZZ%'
) loop
INSERT INTO da.HRBDADMINHEADER_EM@&to_which_database
(  
  BDH_CODE,
  BDH_VENDOR,
  BDH_CODE_TYPE,
  BDH_LONG_CODE,
  BDH_DESCRIPTION,
  BDH_ROW_CREATION_USER,
  BDH_ROW_CREATION_DATE,
  BDH_LAST_UPD_USER,
  BDH_LAST_UPD_DATE--,
  --BDH__IU__CREATE_DATE,
  --BDH__IU__CREATE_USER,
  --BDH__IU__UPDATE_DATE,
  --BDH__IU__UPDATE_USER
)
values
(
i.   BDH_CODE,
i.   BDH_VENDOR,
i.   BDH_CODE_TYPE,
i.   BDH_LONG_CODE,
i.   BDH_DESCRIPTION,
i.   BDH_ROW_CREATION_USER,
i.   BDH_ROW_CREATION_DATE,
i.   BDH_LAST_UPD_USER,
i.   BDH_LAST_UPD_DATE--,
--i.   --BDH__IU__CREATE_DATE,
--i.   --BDH__IU__CREATE_USER,
--i.   --BDH__IU__UPDATE_DATE,
--i.   --BDH__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.HRBDADMINHEADER_EM@&to_which_database
where bdh_code not like 'ZZ%';
dbms_output.put_line ('Inserted '||v_cnt||' records into HRBDADMINHEADER_EM table.');
select count(1) into v_cnt_&to_which_database from da.HRBDADMINHEADER_EM@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.HRBDADMINHEADER_EM@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for HRBDADMINHEADER_EM table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.HRBDADMINHEADER_EM@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);
end;
/ 