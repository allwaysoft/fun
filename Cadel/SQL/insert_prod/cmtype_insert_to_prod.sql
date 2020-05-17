
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  CMT_COMP_CODE,
  CMT_TYPE_CODE,
  CMT_NAME,
  CMT_CLASS_CODE,
  CMT_CHG_ORD_NUMBER_MASK,
  --CMT__IU__CREATE_DATE,
  --CMT__IU__CREATE_USER,
  --CMT__IU__UPDATE_DATE,
  --CMT__IU__UPDATE_USER,
  CMT_PCI_MASK_OVERRIDE_FLAG
FROM DA.CMTYPE@CONV 
WHERE CMT_COMP_CODE not in ('ZZ')
) loop
INSERT INTO DA.CMTYPE
(  
  CMT_COMP_CODE,
  CMT_TYPE_CODE,
  CMT_NAME,
  CMT_CLASS_CODE,
  CMT_CHG_ORD_NUMBER_MASK,
  --CMT__IU__CREATE_DATE,
  --CMT__IU__CREATE_USER,
  --CMT__IU__UPDATE_DATE,
  --CMT__IU__UPDATE_USER,
  CMT_PCI_MASK_OVERRIDE_FLAG
)
values
(
i.    CMT_COMP_CODE,
i.    CMT_TYPE_CODE,
i.    CMT_NAME,
i.    CMT_CLASS_CODE,
i.    CMT_CHG_ORD_NUMBER_MASK,
--i.    --CMT__IU__CREATE_DATE,
--i.    --CMT__IU__CREATE_USER,
--i.    --CMT__IU__UPDATE_DATE,
--i.    --CMT__IU__UPDATE_USER,
i.    CMT_PCI_MASK_OVERRIDE_FLAG

);
end loop;
--commit;
select count(1) into v_cnt_conv from CMTYPE@conv;
select count(1) into v_cnt_prod from CMTYPE@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for CMTYPE table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for CMTYPE table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.CMTYPE@PROD where CMT_COMP_CODE not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into CMTYPE table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.CMTYPE.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 