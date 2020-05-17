
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
  BD_CODE,
  BD_VENDOR,
  BD_CODE_TYPE,
  BD_PLAN_CODE,
  BD_PLO_CODE,
  BD_START_DATE,
  BD_ORASEQ,
  BD_END_DATE,
  BD_VALID_DAYS,
  BD_PROCESS_FRQ_CODE,
  BD_AMOUNT,
  BD_REMITTANCE_FRQ_CODE,
  BD_REMITTANCE_TOT_AMT,
  BD_REMITTANCE_AMT_FOR_AP,
  BD_BASE_CODE,
  BD_VENDOR_COMMENT,
  BD_ROW_CREATION_USER,
  BD_ROW_CREATION_DATE,
  BD_LAST_UPD_USER,
  BD_LAST_UPD_DATE,
  BD_REF_ORASEQ--,
--  BD__IU__CREATE_DATE,
--  BD__IU__CREATE_USER,
--  BD__IU__UPDATE_DATE,
--  BD__IU__UPDATE_USER
FROM da.HRBDADMINDETAIL_EM@&from_which_database 
where bd_code not like 'ZZ%'
) loop
INSERT INTO da.HRBDADMINDETAIL_EM@&to_which_database
(  
  BD_CODE,
  BD_VENDOR,
  BD_CODE_TYPE,
  BD_PLAN_CODE,
  BD_PLO_CODE,
  BD_START_DATE,
  BD_ORASEQ,
  BD_END_DATE,
  BD_VALID_DAYS,
  BD_PROCESS_FRQ_CODE,
  BD_AMOUNT,
  BD_REMITTANCE_FRQ_CODE,
  BD_REMITTANCE_TOT_AMT,
  BD_REMITTANCE_AMT_FOR_AP,
  BD_BASE_CODE,
  BD_VENDOR_COMMENT,
  BD_ROW_CREATION_USER,
  BD_ROW_CREATION_DATE,
  BD_LAST_UPD_USER,
  BD_LAST_UPD_DATE,
  BD_REF_ORASEQ--,
--  BD__IU__CREATE_DATE,
--  BD__IU__CREATE_USER,
--  BD__IU__UPDATE_DATE,
--  BD__IU__UPDATE_USER
)
values
(
i.   BD_CODE,
i.   BD_VENDOR,
i.   BD_CODE_TYPE,
i.   BD_PLAN_CODE,
i.   BD_PLO_CODE,
i.   BD_START_DATE,
i.   BD_ORASEQ,
i.   BD_END_DATE,
i.   BD_VALID_DAYS,
i.   BD_PROCESS_FRQ_CODE,
i.   BD_AMOUNT,
i.   BD_REMITTANCE_FRQ_CODE,
i.   BD_REMITTANCE_TOT_AMT,
i.   BD_REMITTANCE_AMT_FOR_AP,
i.   BD_BASE_CODE,
i.   BD_VENDOR_COMMENT,
i.   BD_ROW_CREATION_USER,
i.   BD_ROW_CREATION_DATE,
i.   BD_LAST_UPD_USER,
i.   BD_LAST_UPD_DATE,
i.   BD_REF_ORASEQ--,
--i. --  BD__IU__CREATE_DATE,
--i. --  BD__IU__CREATE_USER,
--i. --  BD__IU__UPDATE_DATE,
--i. BD__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.HRBDADMINDETAIL_EM@&to_which_database
where bd_code not like 'ZZ%';
dbms_output.put_line ('Inserted '||v_cnt||' records into HRBDADMINDETAIL_EM table, check and commit.');
select count(1) into v_cnt_&to_which_database from da.HRBDADMINDETAIL_EM@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.HRBDADMINDETAIL_EM@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for HRBDADMINDETAIL_EM table.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.HRBDADMINDETAIL_EM@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 