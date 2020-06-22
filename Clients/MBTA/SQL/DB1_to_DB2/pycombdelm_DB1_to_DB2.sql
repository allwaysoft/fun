
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
  CBD_COMP_CODE,
  CBD_BASE_CODE,
  CBD_TRAN_TYPE,
  CBD_TRAN_CODE,
  CBD_HOURS_INCLUDED,
  CBD_FACTOR,
  CBD_USER,
  CBD_LAST_UPD_DATE,
  CBD_THRESHOLD_VALUE,
  CBD_CEILING_VALUE,
  CBD_ROUND_DIRECTION,
  CBD_ROUND_TO_VALUE,
  CBD_TABLE_BASE_CODE,
  CBD_BASE_TRAN_TYPE,
  CBD_APPLY_AFTER_FIRST_CHK_FLAG--,
  --CBD__IU__CREATE_DATE,
  --CBD__IU__CREATE_USER,
  --CBD__IU__UPDATE_DATE,
  --CBD__IU__UPDATE_USER
FROM da.PYCOMBDELM@&from_which_database
where cbd_comp_code not in ('ZZ')
) loop
INSERT INTO da.PYCOMBDELM@&to_which_database
(  
  CBD_COMP_CODE,
  CBD_BASE_CODE,
  CBD_TRAN_TYPE,
  CBD_TRAN_CODE,
  CBD_HOURS_INCLUDED,
  CBD_FACTOR,
  CBD_USER,
  CBD_LAST_UPD_DATE,
  CBD_THRESHOLD_VALUE,
  CBD_CEILING_VALUE,
  CBD_ROUND_DIRECTION,
  CBD_ROUND_TO_VALUE,
  CBD_TABLE_BASE_CODE,
  CBD_BASE_TRAN_TYPE,
  CBD_APPLY_AFTER_FIRST_CHK_FLAG--,
  --CBD__IU__CREATE_DATE,
  --CBD__IU__CREATE_USER,
  --CBD__IU__UPDATE_DATE,
  --CBD__IU__UPDATE_USER
)
values
(
i.   CBD_COMP_CODE,
i.   CBD_BASE_CODE,
i.   CBD_TRAN_TYPE,
i.   CBD_TRAN_CODE,
i.   CBD_HOURS_INCLUDED,
i.   CBD_FACTOR,
i.   CBD_USER,
i.   CBD_LAST_UPD_DATE,
i.   CBD_THRESHOLD_VALUE,
i.   CBD_CEILING_VALUE,
i.   CBD_ROUND_DIRECTION,
i.   CBD_ROUND_TO_VALUE,
i.   CBD_TABLE_BASE_CODE,
i.   CBD_BASE_TRAN_TYPE,
i.   CBD_APPLY_AFTER_FIRST_CHK_FLAG--,
--i.   --CBD__IU__CREATE_DATE,
--i.   --CBD__IU__CREATE_USER,
--i.   --CBD__IU__UPDATE_DATE,
--i.   --CBD__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYCOMBDELM@&to_which_database
where cbd_comp_code not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into PYCOMBDELM table.');
select count(1) into v_cnt_&to_which_database from da.PYCOMBDELM@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYCOMBDELM@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYCOMBDELM table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYCOMBDELM@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 