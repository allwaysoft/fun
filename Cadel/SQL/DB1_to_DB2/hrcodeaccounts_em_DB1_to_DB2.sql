


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
select   
  ACC_COMP_CODE,
  ACC_CODE,
  ACC_CODE_TYPE,
  ACC_DEBIT_ACC_CODE,
  ACC_DEBIT_DEPT_CODE,
  ACC_CREDIT_ACC_CODE,
  ACC_CREDIT_DEPT_CODE,
  ACC_ROW_CREATION_USER,
  ACC_ROW_CREATION_DATE,
  ACC_LAST_UPD_USER,
  ACC_LAST_UPD_DATE--,
--  ACC__IU__CREATE_DATE,
--  ACC__IU__CREATE_USER,
--  ACC__IU__UPDATE_DATE,
--  ACC__IU__UPDATE_USER 
from da.hrcodeaccounts_em@&from_which_database 
where acc_comp_code not in ('ZZ')
) loop
INSERT INTO da.hrcodeaccounts_em@&to_which_database
(  
  ACC_COMP_CODE,
  ACC_CODE,
  ACC_CODE_TYPE,
  ACC_DEBIT_ACC_CODE,
  ACC_DEBIT_DEPT_CODE,
  ACC_CREDIT_ACC_CODE,
  ACC_CREDIT_DEPT_CODE,
  ACC_ROW_CREATION_USER,
  ACC_ROW_CREATION_DATE,
  ACC_LAST_UPD_USER,
  ACC_LAST_UPD_DATE--,
--  ACC__IU__CREATE_DATE,
--  ACC__IU__CREATE_USER,
--  ACC__IU__UPDATE_DATE,
--  ACC__IU__UPDATE_USER 
)
values
(
i.   ACC_COMP_CODE,
i.   ACC_CODE,
i.   ACC_CODE_TYPE,
i.   ACC_DEBIT_ACC_CODE,
i.   ACC_DEBIT_DEPT_CODE,
i.   ACC_CREDIT_ACC_CODE,
i.   ACC_CREDIT_DEPT_CODE,
i.   ACC_ROW_CREATION_USER,
i.   ACC_ROW_CREATION_DATE,
i.   ACC_LAST_UPD_USER,
i.   ACC_LAST_UPD_DATE--,
--i. --  ACC__IU__CREATE_DATE,
--i. --  ACC__IU__CREATE_USER,
--i. --  ACC__IU__UPDATE_DATE,
--i. ACC__IU__UPDATE_USER

);
end loop;
--commit;
select count(1) into v_cnt_&to_which_database from da.hrcodeaccounts_em@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.hrcodeaccounts_em@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for hrcodeaccounts_em table.');
else
dbms_output.put_line ('Number of records in &from_which_database does not match with &to_which_database for PYCOMPAYPRD table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from da.hrcodeaccounts_em@&to_which_database
where acc_comp_code not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into hrcodeaccounts_em table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in &from_which_database and &to_which_database for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.hrcodeaccounts_em@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 