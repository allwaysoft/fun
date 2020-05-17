
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
  DED_CODE,
  DED_DESCRIPTION,
  DED_SHORT_DESC,
  DED_GRP_CODE,
  DED_TYPE,
  DED_AMOUNT,
  DED_BASE_CODE,
  DED_EMPLR_CONTR,
  DED_JOB_ALLOCATION,
  DED_PRIORITY,
  DED_CF_FLAG,
  DED_PRINT_ORDER,
  DED_USER,
  DED_LAST_UPD_DATE,
  DED_CALC_SEQ,
  DED_PARTIAL_CF_FLAG,
  DED_MANDATORY_FLAG,
  DED_FOR_DEP_FLAG,
  DED_INVOICE_FLAG,
  DED_WRL_ALLOCATION,
  DED_CREATE_AP_VOUCHER,
  DED_EXCLUDE_FLAG,
  --DED__IU__CREATE_DATE,
  --DED__IU__CREATE_USER,
  --DED__IU__UPDATE_DATE,
  --DED__IU__UPDATE_USER,
  DED_LIMIT_GRP_CODE
FROM da.PYDEDUCTION@&from_which_database 
where ded_code not like ('ZZ%')
) loop
INSERT INTO DA.PYDEDUCTION@&to_which_database
(  
  DED_CODE,
  DED_DESCRIPTION,
  DED_SHORT_DESC,
  DED_GRP_CODE,
  DED_TYPE,
  DED_AMOUNT,
  DED_BASE_CODE,
  DED_EMPLR_CONTR,
  DED_JOB_ALLOCATION,
  DED_PRIORITY,
  DED_CF_FLAG,
  DED_PRINT_ORDER,
  DED_USER,
  DED_LAST_UPD_DATE,
  DED_CALC_SEQ,
  DED_PARTIAL_CF_FLAG,
  DED_MANDATORY_FLAG,
  DED_FOR_DEP_FLAG,
  DED_INVOICE_FLAG,
  DED_WRL_ALLOCATION,
  DED_CREATE_AP_VOUCHER,
  DED_EXCLUDE_FLAG,
  --DED__IU__CREATE_DATE,
  --DED__IU__CREATE_USER,
  --DED__IU__UPDATE_DATE,
  --DED__IU__UPDATE_USER,
  DED_LIMIT_GRP_CODE
)
values
(
i.  DED_CODE,
i.  DED_DESCRIPTION,
i.  DED_SHORT_DESC,
i.  DED_GRP_CODE,
i.  DED_TYPE,
i.  DED_AMOUNT,
i.  DED_BASE_CODE,
i.  DED_EMPLR_CONTR,
i.  DED_JOB_ALLOCATION,
i.  DED_PRIORITY,
i.  DED_CF_FLAG,
i.  DED_PRINT_ORDER,
i.  DED_USER,
i.  DED_LAST_UPD_DATE,
i.  DED_CALC_SEQ,
i.  DED_PARTIAL_CF_FLAG,
i.  DED_MANDATORY_FLAG,
i.  DED_FOR_DEP_FLAG,
i.  DED_INVOICE_FLAG,
i.  DED_WRL_ALLOCATION,
i.  DED_CREATE_AP_VOUCHER,
i.  DED_EXCLUDE_FLAG,
--i.  --DED__IU__CREATE_DATE,
--i.  --DED__IU__CREATE_USER,
--i.  --DED__IU__UPDATE_DATE,
--i.  --DED__IU__UPDATE_USER,
i.  DED_LIMIT_GRP_CODE
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYDEDUCTION@&to_which_database
where ded_code not like ('ZZ%');
dbms_output.put_line ('Inserted '||v_cnt||' records into PYDEDUCTION table.');
select count(1) into v_cnt_&to_which_database from da.PYDEDUCTION@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYDEDUCTION@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYDEDUCTION table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYDEDUCTION@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 