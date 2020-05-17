
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
  BDR_TABLE_CODE,
  BDR_EFFECTIVE_DATE,
  BDR_LINE_NUMBER,
  BDR_LOOKUP_VALUE,
  BDR_MAX_ORDINATE,
  BDR_LAST_UPD_DATE,
  BDR_USER,
  BDR_LOOKUP_VALUE2,
  BDR_LOOKUP_VALUE3,
  BDR_ROUND_DIRECTION,
  BDR_ROUND_TO_VALUE,
  BDR_ELIGIBLE_FLAG,
  BDR_MIN_ORDINATE,
--  BDR__IU__CREATE_DATE,
--  BDR__IU__CREATE_USER,
--  BDR__IU__UPDATE_DATE,
--  BDR__IU__UPDATE_USER,
  BDR_LOOKUP_VALUE4
FROM da.PYBDTABLEROWS@&from_which_database 
where bdr_table_code not like 'ZZ%'
and bdr_table_code not like 'DEFAULT%'
) loop
INSERT INTO da.PYBDTABLEROWS@&to_which_database
(  
  BDR_TABLE_CODE,
  BDR_EFFECTIVE_DATE,
  BDR_LINE_NUMBER,
  BDR_LOOKUP_VALUE,
  BDR_MAX_ORDINATE,
  BDR_LAST_UPD_DATE,
  BDR_USER,
  BDR_LOOKUP_VALUE2,
  BDR_LOOKUP_VALUE3,
  BDR_ROUND_DIRECTION,
  BDR_ROUND_TO_VALUE,
  BDR_ELIGIBLE_FLAG,
  BDR_MIN_ORDINATE,
--  BDR__IU__CREATE_DATE,
--  BDR__IU__CREATE_USER,
--  BDR__IU__UPDATE_DATE,
--  BDR__IU__UPDATE_USER,
  BDR_LOOKUP_VALUE4
)
values
(
i.   BDR_TABLE_CODE,
i.   BDR_EFFECTIVE_DATE,
i.   BDR_LINE_NUMBER,
i.   BDR_LOOKUP_VALUE,
i.   BDR_MAX_ORDINATE,
i.   BDR_LAST_UPD_DATE,
i.   BDR_USER,
i.   BDR_LOOKUP_VALUE2,
i.   BDR_LOOKUP_VALUE3,
i.   BDR_ROUND_DIRECTION,
i.   BDR_ROUND_TO_VALUE,
i.   BDR_ELIGIBLE_FLAG,
i.   BDR_MIN_ORDINATE,
--i. --  BDR__IU__CREATE_DATE,
--i. --  BDR__IU__CREATE_USER,
--i. --  BDR__IU__UPDATE_DATE,
--i. --  BDR__IU__UPDATE_USER,
i.   BDR_LOOKUP_VALUE4
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYBDTABLEROWS@&to_which_database
where bdr_table_code not like 'ZZ%'
and bdr_table_code not like 'DEFAULT%';
dbms_output.put_line ('Inserted '||v_cnt||' records into PYBDTABLEROWS table.');
select count(1) into v_cnt_&to_which_database from da.PYBDTABLEROWS@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYBDTABLEROWS@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYBDTABLEROWS table, check and commit.');
else
dbms_output.put_line ('Number of records in &from_which_database does not match with &to_which_database for PYBDTABLEROWS table.');
Raise record_count_mismatch;
end if;
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in &from_which_database and &to_which_database for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYBDTABLEROWS@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 