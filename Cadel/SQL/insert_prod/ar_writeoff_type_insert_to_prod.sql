
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  ARWOT_CODE,
  ARWOT_COMP_CODE,
  ARWOT_DESC,
  ARWOT_CREATE_NEW_INVOICE_FLAG,
  ARWOT_ARI_COMP_CODE,
  ARWOT_ARI_INV_SER_CODE,
  ARWOT_WO_DEPT_CODE,
  ARWOT_WO_ACC_CODE--,
--  ARWOT__IU__CREATE_DATE,
--  ARWOT__IU__CREATE_USER,
--  ARWOT__IU__UPDATE_DATE,
--  ARWOT__IU__UPDATE_USER
FROM DA.AR_WRITEOFF_TYPE@CONV 
WHERE arwot_comp_code NOT IN ('ZZ')
) loop
INSERT INTO DA.AR_WRITEOFF_TYPE
(  
  ARWOT_CODE,
  ARWOT_COMP_CODE,
  ARWOT_DESC,
  ARWOT_CREATE_NEW_INVOICE_FLAG,
  ARWOT_ARI_COMP_CODE,
  ARWOT_ARI_INV_SER_CODE,
  ARWOT_WO_DEPT_CODE,
  ARWOT_WO_ACC_CODE--,
--  ARWOT__IU__CREATE_DATE,
--  ARWOT__IU__CREATE_USER,
--  ARWOT__IU__UPDATE_DATE,
--  ARWOT__IU__UPDATE_USER

)
values
(
i.  ARWOT_CODE,
i.  ARWOT_COMP_CODE,
i.  ARWOT_DESC,
i.  ARWOT_CREATE_NEW_INVOICE_FLAG,
i.  ARWOT_ARI_COMP_CODE,
i.  ARWOT_ARI_INV_SER_CODE,
i.  ARWOT_WO_DEPT_CODE,
i.  ARWOT_WO_ACC_CODE--,
--i.--  ARWOT__IU__CREATE_DATE,
--i.--  ARWOT__IU__CREATE_USER,
--i.--  ARWOT__IU__UPDATE_DATE,
--i.--  ARWOT__IU__UPDATE_USER
);
end loop;
--commit;
select count(1) into v_cnt_conv from AR_WRITEOFF_TYPE@conv;
select count(1) into v_cnt_prod from AR_WRITEOFF_TYPE@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for AR_WRITEOFF_TYPE table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for AR_WRITEOFF_TYPE table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.AR_WRITEOFF_TYPE@PROD where arwot_comp_code NOT IN ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into AR_WRITEOFF_TYPE table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.AR_WRITEOFF_TYPE.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 