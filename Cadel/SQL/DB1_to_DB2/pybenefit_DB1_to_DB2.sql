
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
  BEN_CODE,
  BEN_DESCRIPTION,
  BEN_SHORT_DESC,
  BEN_GRP_CODE,
  BEN_PW_FLAG,
  BEN_TYPE,
  BEN_AMOUNT,
  BEN_BASE_CODE,
  BEN_CASH,
  BEN_JOB_ALLOCATION,
  BEN_PRINT_ORDER,
  BEN_DED_CODE,
  BEN_USER,
  BEN_LAST_UPD_DATE,
  BEN_CALC_SEQ,
  BEN_EMPLE_CONTR_FLAG,
  BEN_COMMENT,
  BEN_FOR_DEP_FLAG,
  BEN_CALC_FLAG,
  BEN_WRL_ALLOCATION,
  BEN_JOB_ALLOCATION_ALL,
  BEN_CREATE_AP_VOUCHER,
  BEN_EXCLUDE_FLAG,
  --BEN__IU__CREATE_DATE,
  --BEN__IU__CREATE_USER,
  --BEN__IU__UPDATE_DATE,
  --BEN__IU__UPDATE_USER,
  BEN_PRINT_CHECK_ONLY,
  BEN_ASSIGNED_CHECK_NUM,
  BEN_CREATE_SEPRATE_CHECK,
  BEN_LIMIT_GRP_CODE,
  BEN_INCL_IN_GCF_STAFF_FLAG
FROM DA.PYBENEFIT@&from_which_database
where ben_code not like 'ZZ%'
) loop
INSERT INTO DA.PYBENEFIT@&to_which_database
(  
  BEN_CODE,
  BEN_DESCRIPTION,
  BEN_SHORT_DESC,
  BEN_GRP_CODE,
  BEN_PW_FLAG,
  BEN_TYPE,
  BEN_AMOUNT,
  BEN_BASE_CODE,
  BEN_CASH,
  BEN_JOB_ALLOCATION,
  BEN_PRINT_ORDER,
  BEN_DED_CODE,
  BEN_USER,
  BEN_LAST_UPD_DATE,
  BEN_CALC_SEQ,
  BEN_EMPLE_CONTR_FLAG,
  BEN_COMMENT,
  BEN_FOR_DEP_FLAG,
  BEN_CALC_FLAG,
  BEN_WRL_ALLOCATION,
  BEN_JOB_ALLOCATION_ALL,
  BEN_CREATE_AP_VOUCHER,
  BEN_EXCLUDE_FLAG,
  --BEN__IU__CREATE_DATE,
  --BEN__IU__CREATE_USER,
  --BEN__IU__UPDATE_DATE,
  --BEN__IU__UPDATE_USER,
  BEN_PRINT_CHECK_ONLY,
  BEN_ASSIGNED_CHECK_NUM,
  BEN_CREATE_SEPRATE_CHECK,
  BEN_LIMIT_GRP_CODE,
  BEN_INCL_IN_GCF_STAFF_FLAG
)
values
(
i.  BEN_CODE,
i.  BEN_DESCRIPTION,
i.  BEN_SHORT_DESC,
i.  BEN_GRP_CODE,
i.  BEN_PW_FLAG,
i.  BEN_TYPE,
i.  BEN_AMOUNT,
i.  BEN_BASE_CODE,
i.  BEN_CASH,
i.  BEN_JOB_ALLOCATION,
i.  BEN_PRINT_ORDER,
i.  BEN_DED_CODE,
i.  BEN_USER,
i.  BEN_LAST_UPD_DATE,
i.  BEN_CALC_SEQ,
i.  BEN_EMPLE_CONTR_FLAG,
i.  BEN_COMMENT,
i.  BEN_FOR_DEP_FLAG,
i.  BEN_CALC_FLAG,
i.  BEN_WRL_ALLOCATION,
i.  BEN_JOB_ALLOCATION_ALL,
i.  BEN_CREATE_AP_VOUCHER,
i.  BEN_EXCLUDE_FLAG,
--i.  --BEN__IU__CREATE_DATE,
--i.  --BEN__IU__CREATE_USER,
--i.  --BEN__IU__UPDATE_DATE,
--i.  --BEN__IU__UPDATE_USER,
i.  BEN_PRINT_CHECK_ONLY,
i.  BEN_ASSIGNED_CHECK_NUM,
i.  BEN_CREATE_SEPRATE_CHECK,
i.  BEN_LIMIT_GRP_CODE,
i.  BEN_INCL_IN_GCF_STAFF_FLAG
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYBENEFIT@&to_which_database
where ben_code not like 'ZZ%';
dbms_output.put_line ('Inserted '||v_cnt||' records into PYBENEFIT table.');
select count(1) into v_cnt_&to_which_database from da.PYBENEFIT@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYBENEFIT@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYBENEFIT table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYBENEFIT@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 