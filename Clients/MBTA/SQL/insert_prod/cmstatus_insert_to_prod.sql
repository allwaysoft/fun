
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  CMST_COMP_CODE,
  CMST_STAT_CODE,
  CMST_STAT_NAME,
  CMST_PENDING_TYPE_CODE,
  CMST_PROCEEDING_FLAG,
  CMST_INCL_FORECAST_FLAG,
  --CMST__IU__CREATE_DATE,
  --CMST__IU__CREATE_USER,
  --CMST__IU__UPDATE_DATE,
  --CMST__IU__UPDATE_USER,
  CMST_PCI_BILLING_FLAG
FROM DA.CMSTATUS@CONV
WHERE CMST_COMP_CODE not in ('ZZ')
) loop
INSERT INTO DA.CMSTATUS
(  
  CMST_COMP_CODE,
  CMST_STAT_CODE,
  CMST_STAT_NAME,
  CMST_PENDING_TYPE_CODE,
  CMST_PROCEEDING_FLAG,
  CMST_INCL_FORECAST_FLAG,
  --CMST__IU__CREATE_DATE,
  --CMST__IU__CREATE_USER,
  --CMST__IU__UPDATE_DATE,
  --CMST__IU__UPDATE_USER,
  CMST_PCI_BILLING_FLAG
)
values
(
i.    CMST_COMP_CODE,
i.    CMST_STAT_CODE,
i.    CMST_STAT_NAME,
i.    CMST_PENDING_TYPE_CODE,
i.    CMST_PROCEEDING_FLAG,
i.    CMST_INCL_FORECAST_FLAG,
--i.    --CMST__IU__CREATE_DATE,
--i.    --CMST__IU__CREATE_USER,
--i.    --CMST__IU__UPDATE_DATE,
--i.    --CMST__IU__UPDATE_USER,
i.    CMST_PCI_BILLING_FLAG
);
end loop;
--commit;
select count(1) into v_cnt_conv from CMSTATUS@conv;
select count(1) into v_cnt_prod from CMSTATUS@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for CMSTATUS table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for CMSTATUS table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.CMSTATUS@PROD where CMST_COMP_CODE not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into CMSTATUS table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.CMSTATUS.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 