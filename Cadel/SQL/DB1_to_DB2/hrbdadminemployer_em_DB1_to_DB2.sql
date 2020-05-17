
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
  BDE_ORASEQ,
  BDE_COMP_CODE,
  BDE_PRN_CODE,
  BDE_EMPLR_CONTR_FACTOR,
  BDE_CONTR_AMT,
  BDE_CONTR_MAX_TYPE,
  BDE_CONTR_MAX_AMT,
  BDE_EMPLR_CONTR_ACC_CODE,
  BDE_EMPLR_CONTR_DEPT_CODE,
  BDE_TABLE_BASE,
  BDE_ROW_CREATION_USER,
  BDE_ROW_CREATION_DATE,
  BDE_LAST_UPD_USER,
  BDE_LAST_UPD_DATE--,
  --BDE__IU__CREATE_DATE,
  --BDE__IU__CREATE_USER,
  --BDE__IU__UPDATE_DATE,
  --BDE__IU__UPDATE_USER
FROM DA.HRBDADMINEMPLOYER_EM@&from_which_database 
where bde_comp_code not in ('ZZ')
) loop
INSERT INTO DA.HRBDADMINEMPLOYER_EM@&to_which_database
(  
  BDE_ORASEQ,
  BDE_COMP_CODE,
  BDE_PRN_CODE,
  BDE_EMPLR_CONTR_FACTOR,
  BDE_CONTR_AMT,
  BDE_CONTR_MAX_TYPE,
  BDE_CONTR_MAX_AMT,
  BDE_EMPLR_CONTR_ACC_CODE,
  BDE_EMPLR_CONTR_DEPT_CODE,
  BDE_TABLE_BASE,
  BDE_ROW_CREATION_USER,
  BDE_ROW_CREATION_DATE,
  BDE_LAST_UPD_USER,
  BDE_LAST_UPD_DATE--,
  --BDE__IU__CREATE_DATE,
  --BDE__IU__CREATE_USER,
  --BDE__IU__UPDATE_DATE,
  --BDE__IU__UPDATE_USER
)
values
(
i.   BDE_ORASEQ,
i.   BDE_COMP_CODE,
i.   BDE_PRN_CODE,
i.   BDE_EMPLR_CONTR_FACTOR,
i.   BDE_CONTR_AMT,
i.   BDE_CONTR_MAX_TYPE,
i.   BDE_CONTR_MAX_AMT,
i.   BDE_EMPLR_CONTR_ACC_CODE,
i.   BDE_EMPLR_CONTR_DEPT_CODE,
i.   BDE_TABLE_BASE,
i.   BDE_ROW_CREATION_USER,
i.   BDE_ROW_CREATION_DATE,
i.   BDE_LAST_UPD_USER,
i.   BDE_LAST_UPD_DATE--,
--i.   --BDE__IU__CREATE_DATE,
--i.   --BDE__IU__CREATE_USER,
--i.   --BDE__IU__UPDATE_DATE,
--i.   --BDE__IU__UPDATE_USER

);
end loop;
--commit;
Select count(1) into v_cnt from da.HRBDADMINEMPLOYER_EM@&to_which_database
where bde_comp_code not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into HRBDADMINEMPLOYER_EM table.');
select count(1) into v_cnt_&to_which_database from da.HRBDADMINEMPLOYER_EM@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.HRBDADMINEMPLOYER_EM@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for HRBDADMINEMPLOYER_EM table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.HRBDADMINEMPLOYER_EM@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 