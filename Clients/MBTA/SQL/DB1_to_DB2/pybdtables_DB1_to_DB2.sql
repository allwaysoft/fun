
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
  BDT_TABLE_CODE,
  BDT_TABLE_DESC,
  BDT_EFFECTIVE_DATE,
  BDT_LAST_UPD_DATE,
  BDT_USER,
  BDT_BASED_ON,
  BDT_USAGE,
  BDT_SCAN_TYPE,
  BDT_YRSRVC_PER,
  BDT_TABLE_TYPE--,
--  BDT__IU__CREATE_DATE,
--  BDT__IU__CREATE_USER,
--  BDT__IU__UPDATE_DATE,
--  BDT__IU__UPDATE_USER
FROM da.PYBDTABLES@&from_which_database 
where bdt_table_code not like 'ZZ%'
and bdt_table_code not like 'DEFAULT%'
) loop
INSERT INTO da.PYBDTABLES@&to_which_database
(  
  BDT_TABLE_CODE,
  BDT_TABLE_DESC,
  BDT_EFFECTIVE_DATE,
  BDT_LAST_UPD_DATE,
  BDT_USER,
  BDT_BASED_ON,
  BDT_USAGE,
  BDT_SCAN_TYPE,
  BDT_YRSRVC_PER,
  BDT_TABLE_TYPE--,
--  BDT__IU__CREATE_DATE,
--  BDT__IU__CREATE_USER,
--  BDT__IU__UPDATE_DATE,
--  BDT__IU__UPDATE_USER
)
values
(
i.   BDT_TABLE_CODE,
i.   BDT_TABLE_DESC,
i.   BDT_EFFECTIVE_DATE,
i.   BDT_LAST_UPD_DATE,
i.   BDT_USER,
i.   BDT_BASED_ON,
i.   BDT_USAGE,
i.   BDT_SCAN_TYPE,
i.   BDT_YRSRVC_PER,
i.   BDT_TABLE_TYPE--,
--i. --  BDT__IU__CREATE_DATE,
--i. --  BDT__IU__CREATE_USER,
--i. --  BDT__IU__UPDATE_DATE,
--i. BDT__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYBDTABLES@&to_which_database
where bdt_table_code not like 'ZZ%'
and bdt_table_code not like 'DEFAULT%';
dbms_output.put_line ('Inserted '||v_cnt||' records into PYBDTABLES table.');
select count(1) into v_cnt_&to_which_database from da.PYBDTABLES@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYBDTABLES@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYBDTABLES table, check and commit.');
else
dbms_output.put_line ('Number of records in PROD does not match with &to_which_database for PYCOMPAYPRD table.');
Raise record_count_mismatch;
end if;
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in &from_which_database and &to_which_database for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYBDTABLES@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 