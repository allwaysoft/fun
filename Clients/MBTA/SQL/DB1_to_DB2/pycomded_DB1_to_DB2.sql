
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
  COD_ELEG_AMT,
  COD_ELEG_BASE_CODE,
  COD_USER,
  COD_LAST_UPD_DATE,
  COD_BASE_CODE,
  COD_DED_CODE,
  COD_START_DATE,
  COD_END_DATE,
  COD_FRQ_CODE,
  COD_DED_AMOUNT,
  COD_EMPLR_CONTR_FACTOR,
  COD_CONTR_AMT,
  COD_CONTR_MAX_AMT,
  COD_GL_ACC_CODE,
  COD_EMPLR_CONTR_ACC_CODE,
  COD_ELEG_FRQ_CODE,
  COD_DEPT_CODE,
  COD_EMPLR_CONTR_DEPT_CODE,
  COD_DED_TYPE,
  COD_PLAN_CODE,
  COD_PLO_CODE,
  COD_VENDOR,
  COD_COMP_CODE,
  COD_PRN_CODE,
  COD_PYG_CODE,
  COD_PRINT_DED_FLAG,
  COD_CALC_AFTER_FIRST_CHK_FLAG,
  COD_CONTR_MAX_TYPE,
  COD_EMPLR_CONTR_EFFECTIVE_DATE,
  COD_BD_ORASEQ,
  COD_COMMENT,
  COD_REMITTANCE_AMT_FOR_AP,
  COD_REMITTANCE_FRQ_CODE,
  COD_REMITTANCE_TOT_AMT,
  COD_DED_SECURE_FLAG--,
  --COD__IU__CREATE_DATE,
  --COD__IU__CREATE_USER,
  --COD__IU__UPDATE_DATE,
  --COD__IU__UPDATE_USER
FROM da.PYCOMDED@&from_which_database
where cod_ded_code not like 'ZZ%'
) loop
INSERT INTO DA.PYCOMDED@&to_which_database
(  
  COD_ELEG_AMT,
  COD_ELEG_BASE_CODE,
  COD_USER,
  COD_LAST_UPD_DATE,
  COD_BASE_CODE,
  COD_DED_CODE,
  COD_START_DATE,
  COD_END_DATE,
  COD_FRQ_CODE,
  COD_DED_AMOUNT,
  COD_EMPLR_CONTR_FACTOR,
  COD_CONTR_AMT,
  COD_CONTR_MAX_AMT,
  COD_GL_ACC_CODE,
  COD_EMPLR_CONTR_ACC_CODE,
  COD_ELEG_FRQ_CODE,
  COD_DEPT_CODE,
  COD_EMPLR_CONTR_DEPT_CODE,
  COD_DED_TYPE,
  COD_PLAN_CODE,
  COD_PLO_CODE,
  COD_VENDOR,
  COD_COMP_CODE,
  COD_PRN_CODE,
  COD_PYG_CODE,
  COD_PRINT_DED_FLAG,
  COD_CALC_AFTER_FIRST_CHK_FLAG,
  COD_CONTR_MAX_TYPE,
  COD_EMPLR_CONTR_EFFECTIVE_DATE,
  COD_BD_ORASEQ,
  COD_COMMENT,
  COD_REMITTANCE_AMT_FOR_AP,
  COD_REMITTANCE_FRQ_CODE,
  COD_REMITTANCE_TOT_AMT,
  COD_DED_SECURE_FLAG--,
  --COD__IU__CREATE_DATE,
  --COD__IU__CREATE_USER,
  --COD__IU__UPDATE_DATE,
  --COD__IU__UPDATE_USER
)
values
(
i.  COD_ELEG_AMT,
i.  COD_ELEG_BASE_CODE,
i.  COD_USER,
i.  COD_LAST_UPD_DATE,
i.  COD_BASE_CODE,
i.  COD_DED_CODE,
i.  COD_START_DATE,
i.  COD_END_DATE,
i.  COD_FRQ_CODE,
i.  COD_DED_AMOUNT,
i.  COD_EMPLR_CONTR_FACTOR,
i.  COD_CONTR_AMT,
i.  COD_CONTR_MAX_AMT,
i.  COD_GL_ACC_CODE,
i.  COD_EMPLR_CONTR_ACC_CODE,
i.  COD_ELEG_FRQ_CODE,
i.  COD_DEPT_CODE,
i.  COD_EMPLR_CONTR_DEPT_CODE,
i.  COD_DED_TYPE,
i.  COD_PLAN_CODE,
i.  COD_PLO_CODE,
i.  COD_VENDOR,
i.  COD_COMP_CODE,
i.  COD_PRN_CODE,
i.  COD_PYG_CODE,
i.  COD_PRINT_DED_FLAG,
i.  COD_CALC_AFTER_FIRST_CHK_FLAG,
i.  COD_CONTR_MAX_TYPE,
i.  COD_EMPLR_CONTR_EFFECTIVE_DATE,
i.  COD_BD_ORASEQ,
i.  COD_COMMENT,
i.  COD_REMITTANCE_AMT_FOR_AP,
i.  COD_REMITTANCE_FRQ_CODE,
i.  COD_REMITTANCE_TOT_AMT,
i.  COD_DED_SECURE_FLAG--,
--i.  --COD__IU__CREATE_DATE,
--i.  --COD__IU__CREATE_USER,
--i.  --COD__IU__UPDATE_DATE,
--i.  --COD__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYCOMDED@&to_which_database
where cod_ded_code not like 'ZZ%';
dbms_output.put_line ('Inserted '||v_cnt||' records into PYCOMDED table.');
select count(1) into v_cnt_&to_which_database from da.PYCOMDED@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYCOMDED@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYCOMDED table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYCOMDED@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 