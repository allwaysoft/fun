
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
  COB_EMPLE_CONTR_ACC_CODE,
  COB_VENDOR,
  COB_COMP_CODE,
  COB_PRN_CODE,
  COB_PYG_CODE,
  COB_BEN_CODE,
  COB_START_DATE,
  COB_END_DATE,
  COB_FRQ_CODE,
  COB_BEN_AMOUNT,
  COB_DR_ACC_CODE,
  COB_EMPLR_CONTR_DEPT_CODE,
  COB_PLAN_CODE,
  COB_PLO_CODE,
  COB_BEN_TYPE,
  COB_EMPLE_CONTR_FACTOR,
  COB_CONTR_AMT,
  COB_CONTR_MAX_AMT,
  COB_CR_ACC_CODE,
  COB_ELEG_FRQ_CODE,
  COB_ELEG_AMT,
  COB_ELEG_BASE_CODE,
  COB_USER,
  COB_LAST_UPD_DATE,
  COB_BASE_CODE,
  COB_DEPT_CODE,
  COB_PRINT_BEN_FLAG,
  COB_CALC_AFTER_FIRST_CHK_FLAG,
  COB_BD_ORASEQ,
  COB_COMMENT,
  COB_REMITTANCE_AMT_FOR_AP,
  COB_REMITTANCE_FRQ_CODE,
  COB_REMITTANCE_TOT_AMT,
  COB_BEN_SECURE_FLAG--,
  --COB__IU__CREATE_DATE,
  --COB__IU__CREATE_USER,
  --COB__IU__UPDATE_DATE,
  --COB__IU__UPDATE_USER
FROM da.PYCOMBEN@&from_which_database
where cob_comp_code not in ('ZZ')
) loop
INSERT INTO DA.PYCOMBEN@&to_which_database
(  
  COB_EMPLE_CONTR_ACC_CODE,
  COB_VENDOR,
  COB_COMP_CODE,
  COB_PRN_CODE,
  COB_PYG_CODE,
  COB_BEN_CODE,
  COB_START_DATE,
  COB_END_DATE,
  COB_FRQ_CODE,
  COB_BEN_AMOUNT,
  COB_DR_ACC_CODE,
  COB_EMPLR_CONTR_DEPT_CODE,
  COB_PLAN_CODE,
  COB_PLO_CODE,
  COB_BEN_TYPE,
  COB_EMPLE_CONTR_FACTOR,
  COB_CONTR_AMT,
  COB_CONTR_MAX_AMT,
  COB_CR_ACC_CODE,
  COB_ELEG_FRQ_CODE,
  COB_ELEG_AMT,
  COB_ELEG_BASE_CODE,
  COB_USER,
  COB_LAST_UPD_DATE,
  COB_BASE_CODE,
  COB_DEPT_CODE,
  COB_PRINT_BEN_FLAG,
  COB_CALC_AFTER_FIRST_CHK_FLAG,
  COB_BD_ORASEQ,
  COB_COMMENT,
  COB_REMITTANCE_AMT_FOR_AP,
  COB_REMITTANCE_FRQ_CODE,
  COB_REMITTANCE_TOT_AMT,
  COB_BEN_SECURE_FLAG--,
  --COB__IU__CREATE_DATE,
  --COB__IU__CREATE_USER,
  --COB__IU__UPDATE_DATE,
  --COB__IU__UPDATE_USER
)
values
(
i.  COB_EMPLE_CONTR_ACC_CODE,
i.  COB_VENDOR,
i.  COB_COMP_CODE,
i.  COB_PRN_CODE,
i.  COB_PYG_CODE,
i.  COB_BEN_CODE,
i.  COB_START_DATE,
i.  COB_END_DATE,
i.  COB_FRQ_CODE,
i.  COB_BEN_AMOUNT,
i.  COB_DR_ACC_CODE,
i.  COB_EMPLR_CONTR_DEPT_CODE,
i.  COB_PLAN_CODE,
i.  COB_PLO_CODE,
i.  COB_BEN_TYPE,
i.  COB_EMPLE_CONTR_FACTOR,
i.  COB_CONTR_AMT,
i.  COB_CONTR_MAX_AMT,
i.  COB_CR_ACC_CODE,
i.  COB_ELEG_FRQ_CODE,
i.  COB_ELEG_AMT,
i.  COB_ELEG_BASE_CODE,
i.  COB_USER,
i.  COB_LAST_UPD_DATE,
i.  COB_BASE_CODE,
i.  COB_DEPT_CODE,
i.  COB_PRINT_BEN_FLAG,
i.  COB_CALC_AFTER_FIRST_CHK_FLAG,
i.  COB_BD_ORASEQ,
i.  COB_COMMENT,
i.  COB_REMITTANCE_AMT_FOR_AP,
i.  COB_REMITTANCE_FRQ_CODE,
i.  COB_REMITTANCE_TOT_AMT,
i.  COB_BEN_SECURE_FLAG--,
--i.  --COB__IU__CREATE_DATE,
--i.  --COB__IU__CREATE_USER,
--i.  --COB__IU__UPDATE_DATE,
--i.  --COB__IU__UPDATE_USER

);
end loop;
--commit;
Select count(1) into v_cnt from da.PYCOMBEN@&to_which_database
where cob_comp_code not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into PYCOMBEN table.');
select count(1) into v_cnt_&to_which_database from da.PYCOMBEN@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYCOMBEN@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYCOMBEN table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYCOMBEN@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 