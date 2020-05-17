
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


begin
for i in
(
SELECT 
  TAX_CODE,
  TAX_DESCRIPTION,
  TAX_SHORT_DESCRIPTION,
  TAX_GRP_CODE,
  TAX_LEVEL,
  TAX_PAID_EMPLR,
  TAX_JOB_ALLOCATION,
  TAX_VERTEX_TAXID,
  TAX_CALCMETH,
  TAX_ALT_CALC_CODE,
  TAX_PRINT_ORDER,
  TAX_SS_FLAG,
  TAX_USER,
  TAX_LAST_UPD_DATE,
  TAX_REAL_VERTEX_TAX_ID,
  TAX_CREATE_AP_VOUCHER--,
  --TAX__IU__CREATE_DATE,
  --TAX__IU__CREATE_USER,
  --TAX__IU__UPDATE_DATE,
  --TAX__IU__UPDATE_USER
FROM da.PYTAX@&from_which_database
WHERE tax_description not like 'ZZ%'
) loop
INSERT INTO da.PYTAX@&to_which_database
(  
  TAX_CODE,
  TAX_DESCRIPTION,
  TAX_SHORT_DESCRIPTION,
  TAX_GRP_CODE,
  TAX_LEVEL,
  TAX_PAID_EMPLR,
  TAX_JOB_ALLOCATION,
  TAX_VERTEX_TAXID,
  TAX_CALCMETH,
  TAX_ALT_CALC_CODE,
  TAX_PRINT_ORDER,
  TAX_SS_FLAG,
  TAX_USER,
  TAX_LAST_UPD_DATE,
  TAX_REAL_VERTEX_TAX_ID,
  TAX_CREATE_AP_VOUCHER--,
  --TAX__IU__CREATE_DATE,
  --TAX__IU__CREATE_USER,
  --TAX__IU__UPDATE_DATE,
  --TAX__IU__UPDATE_USER
)
values
(
i.  TAX_CODE,
i.  TAX_DESCRIPTION,
i.  TAX_SHORT_DESCRIPTION,
i.  TAX_GRP_CODE,
i.  TAX_LEVEL,
i.  TAX_PAID_EMPLR,
i.  TAX_JOB_ALLOCATION,
i.  TAX_VERTEX_TAXID,
i.  TAX_CALCMETH,
i.  TAX_ALT_CALC_CODE,
i.  TAX_PRINT_ORDER,
i.  TAX_SS_FLAG,
i.  TAX_USER,
i.  TAX_LAST_UPD_DATE,
i.  TAX_REAL_VERTEX_TAX_ID,
i.  TAX_CREATE_AP_VOUCHER--,
--i.  --TAX__IU__CREATE_DATE,
--i.  --TAX__IU__CREATE_USER,
--i.  --TAX__IU__UPDATE_DATE,
--i.  --TAX__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYTAX@&to_which_database
WHERE tax_description not like 'ZZ%';
dbms_output.put_line ('Inserted '||v_cnt||' records into PYTAX table.');
select count(1) into v_cnt_&to_which_database from da.PYTAX@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYTAX@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYTAX table, check and commit.');
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
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYTAX@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;














for i in
(
SELECT 
  TXE_STATE_CODE,
  TXE_TAX_CODE,
  TXE_EFFECTIVE_DATE,
  TXE_ELM_TYPE,
  TXE_ELM_CODE,
  TXE_END_DATE,
  TXE_PAY_TYPE,
  TXE_CASH,
  TXE_DEDID,
  TXE_USER,
  TXE_LAST_UPD_DATE,
  TXE_EXCLUDE_FLAG--,
  --TXE__IU__CREATE_DATE,
  --TXE__IU__CREATE_USER,
  --TXE__IU__UPDATE_DATE,
  --TXE__IU__UPDATE_USER
FROM da.PYTAXELM@&from_which_database
where txe_elm_code not like 'ZZ%'
) loop
INSERT INTO da.PYTAXELM@&to_which_database
(  
  TXE_STATE_CODE,
  TXE_TAX_CODE,
  TXE_EFFECTIVE_DATE,
  TXE_ELM_TYPE,
  TXE_ELM_CODE,
  TXE_END_DATE,
  TXE_PAY_TYPE,
  TXE_CASH,
  TXE_DEDID,
  TXE_USER,
  TXE_LAST_UPD_DATE,
  TXE_EXCLUDE_FLAG--,
  --TXE__IU__CREATE_DATE,
  --TXE__IU__CREATE_USER,
  --TXE__IU__UPDATE_DATE,
  --TXE__IU__UPDATE_USER
)
values
(
i.  TXE_STATE_CODE,
i.  TXE_TAX_CODE,
i.  TXE_EFFECTIVE_DATE,
i.  TXE_ELM_TYPE,
i.  TXE_ELM_CODE,
i.  TXE_END_DATE,
i.  TXE_PAY_TYPE,
i.  TXE_CASH,
i.  TXE_DEDID,
i.  TXE_USER,
i.  TXE_LAST_UPD_DATE,
i.  TXE_EXCLUDE_FLAG--,
--i.  --TXE__IU__CREATE_DATE,
--i.  --TXE__IU__CREATE_USER,
--i.  --TXE__IU__UPDATE_DATE,
--i.  --TXE__IU__UPDATE_USER
);
end loop;
--commit;
Select count(1) into v_cnt from da.PYTAXELM@&to_which_database
where txe_elm_code not like 'ZZ%';
dbms_output.put_line ('Inserted '||v_cnt||' records into PYTAXELM table.');
select count(1) into v_cnt_&to_which_database from da.PYTAXELM@&to_which_database;
select count(1) into v_cnt_&from_which_database from da.PYTAXELM@&from_which_database;
if v_cnt_&to_which_database - v_cnt_&from_which_database = 0
then
dbms_output.put_line ('Number of records in &to_which_database match with &from_which_database for PYTAXELM table, check and commit.');
else
dbms_output.put_line ('Number of records in &to_which_database does not match with &from_which_database for PYCOMPAYPRD table.');
Raise record_count_mismatch;
end if;
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in &to_which_database and &from_which_database for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO da.PYTAXELM@&to_which_database.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 