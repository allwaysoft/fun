
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  ARI_INV_SER_CODE,
  ARI_INV_SER_DESC,
  ARI_INV_NUM_MASK,
  ARI_INV_SEQ_NUM,
  ARI_AR_DEPT_CODE,
  ARI_ARI_AR_ACC_CODE,
  ARI_COMP_CODE,
  ARI_SEQ_CODE,
  ARI_AR_ACC_CODE,
  ARI_HLDBK_DEPT_CODE,
  ARI_HLDBK_ACC_CODE,
  ARI_DISC_DEPT,
  ARI_DISC_ACC--,
--  ARI__IU__CREATE_DATE,
--  ARI__IU__CREATE_USER,
--  ARI__IU__UPDATE_DATE,
--  ARI__IU__UPDATE_USER
FROM DA.ARINVSERC@CONV
WHERE ARI_COMP_CODE NOT IN ('ZZ')
) loop
INSERT INTO DA.ARINVSERC
(  
  ARI_INV_SER_CODE,
  ARI_INV_SER_DESC,
  ARI_INV_NUM_MASK,
  ARI_INV_SEQ_NUM,
  ARI_AR_DEPT_CODE,
  ARI_ARI_AR_ACC_CODE,
  ARI_COMP_CODE,
  ARI_SEQ_CODE,
  ARI_AR_ACC_CODE,
  ARI_HLDBK_DEPT_CODE,
  ARI_HLDBK_ACC_CODE,
  ARI_DISC_DEPT,
  ARI_DISC_ACC--,
--  ARI__IU__CREATE_DATE,
--  ARI__IU__CREATE_USER,
--  ARI__IU__UPDATE_DATE,
--  ARI__IU__UPDATE_USER
)
values
(
i.  ARI_INV_SER_CODE,
i.  ARI_INV_SER_DESC,
i.  ARI_INV_NUM_MASK,
i.  ARI_INV_SEQ_NUM,
i.  ARI_AR_DEPT_CODE,
i.  ARI_ARI_AR_ACC_CODE,
i.  ARI_COMP_CODE,
i.  ARI_SEQ_CODE,
i.  ARI_AR_ACC_CODE,
i.  ARI_HLDBK_DEPT_CODE,
i.  ARI_HLDBK_ACC_CODE,
i.  ARI_DISC_DEPT,
i.  ARI_DISC_ACC--,
--i.  ARI__IU__CREATE_DATE,
--i.  ARI__IU__CREATE_USER,
--i.  ARI__IU__UPDATE_DATE,
--i.  ARI__IU__UPDATE_USER
);
end loop;
--commit;
select count(1) into v_cnt_conv from ARINVSERC@conv;
select count(1) into v_cnt_prod from ARINVSERC@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for ARINVSERC table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for ARINVSERC table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.ARINVSERC@PROD where ARI_comp_code not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into ARINVSERC table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.ARINVSERC.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 