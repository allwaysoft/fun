
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
  BDM_CODE,
  BDM_CODE_TYPE,
  BDM_TYPE,
  BDM_DESCRIPTION,
  BDM_SHORT_DESC,
  BDM_JOB_ALLOCATION,
  BDM_FOR_DEP_FLAG,
  BDM_WRL_ALLOCATION,
  BDM_CREATE_AP_VOUCHER,
  BDM_CALC_SEQ,
  BDM_PRINT_ORDER,
  BDM_BEN_PW_FLAG,
  BDM_BEN_CASH,
  BDM_BEN_JOB_ALLOCATION_ALL,
  BDM_DED_MANDATORY_FLAG,
  BDM_DED_EMPLR_CONTR,
  BDM_DED_CF_FLAG,
  BDM_DED_INVOICE_FLAG,
  BDM_DED_PRIORITY,
  BDM_ROW_CREATION_USER,
  BDM_ROW_CREATION_DATE,
  BDM_LAST_UPD_USER,
  BDM_LAST_UPD_DATE,
  BDM_BEN_CALC_FLAG,
  BDM_BEN_EXCLUDE_FLAG,
  BDM_DED_EXCLUDE_FLAG--,
  --BDM__IU__CREATE_DATE,
  --BDM__IU__CREATE_USER,
  --BDM__IU__UPDATE_DATE,
  --BDM__IU__UPDATE_USER
FROM da.HRBDADMINMASTER_EM@&from_which_database 
where bdm_code not like 'ZZ%'
) loop
INSERT INTO da.HRBDADMINMASTER_EM@&to_which_database
(  
  BDM_CODE,
  BDM_CODE_TYPE,
  BDM_TYPE,
  BDM_DESCRIPTION,
  BDM_SHORT_DESC,
  BDM_JOB_ALLOCATION,
  BDM_FOR_DEP_FLAG,
  BDM_WRL_ALLOCATION,
  BDM_CREATE_AP_VOUCHER,
  BDM_CALC_SEQ,
  BDM_PRINT_ORDER,
  BDM_BEN_PW_FLAG,
  BDM_BEN_CASH,
  BDM_BEN_JOB_ALLOCATION_ALL,
  BDM_DED_MANDATORY_FLAG,
  BDM_DED_EMPLR_CONTR,
  BDM_DED_CF_FLAG,
  BDM_DED_INVOICE_FLAG,
  BDM_DED_PRIORITY,
  BDM_ROW_CREATION_USER,
  BDM_ROW_CREATION_DATE,
  BDM_LAST_UPD_USER,
  BDM_LAST_UPD_DATE,
  BDM_BEN_CALC_FLAG,
  BDM_BEN_EXCLUDE_FLAG,
  BDM_DED_EXCLUDE_FLAG--,
  --BDM__IU__CREATE_DATE,
  --BDM__IU__CREATE_USER,
  --BDM__IU__UPDATE_DATE,
  --BDM__IU__UPDATE_USER
)
values
(
i.  BDM_CODE,
i.  BDM_CODE_TYPE,
i.  BDM_TYPE,
i.  BDM_DESCRIPTION,
i.  BDM_SHORT_DESC,
i.  BDM_JOB_ALLOCATION,
i.  BDM_FOR_DEP_FLAG,
i.  BDM_WRL_ALLOCATION,
i.  BDM_CREATE_AP_VOUCHER,
i.  BDM_CALC_SEQ,
i.  BDM_PRINT_ORDER,
i.  BDM_BEN_PW_FLAG,
i.  BDM_BEN_CASH,
i.  BDM_BEN_JOB_ALLOCATION_ALL,
i.  BDM_DED_MANDATORY_FLAG,
i.  BDM_DED_EMPLR_CONTR,
i.  BDM_DED_CF_FLAG,
i.  BDM_DED_INVOICE_FLAG,
i.  BDM_DED_PRIORITY,
i.  BDM_ROW_CREATION_USER,
i.  BDM_ROW_CREATION_DATE,
i.  BDM_LAST_UPD_USER,
i.  BDM_LAST_UPD_DATE,
i.  BDM_BEN_CALC_FLAG,
i.  BDM_BEN_EXCLUDE_FLAG,
i.  BDM_DED_EXCLUDE_FLAG--,
--i.  --BDM__IU__CREATE_DATE,
--i.  --BDM__IU__CREATE_USER,
--i.  --BDM__IU__UPDATE_DATE,
--i.  --BDM__IU__UPDATE_USER

);
end loop;
--commit;
Select count(1) into v_cnt from da.HRBDADMINMASTER_EM@&to_which_database
where bdm_code not like 'ZZ%';
dbms_output.put_line ('Inserted '||v_cnt||' records into HRBDADMINMASTER_EM table.');
select count(1) into v_cnt_&to_which_database from da.HRBDADMINMASTER_EM@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.HRBDADMINMASTER_EM@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for HRBDADMINMASTER_EM table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.HRBDADMINMASTER_EM@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 