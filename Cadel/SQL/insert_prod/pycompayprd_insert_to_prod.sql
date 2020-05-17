
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  PYG_COMP_CODE,
  PYG_CODE,
  PYG_DESCRIPTION,
  PYG_SHORT_DESC,
  PYG_BANK_CODE,
  PYG_BRANCH_CODE,
  PYG_BANK_ACC_NUMBER,
  PYG_CR_ACC_CODE,
  PYG_USER,
  PYG_LAST_UPD_DATE,
  PYG_DEPT_CODE,
  PYG_SIGN_FILE1,
  PYG_SIGN_FILE2,
  PYG_COMPANY_LOGO_FILE,
  PYG_PRINT_ADDRESS_FLAG,
  PYG_SECURE_FLAG,
  PYG_AMT_FOR_MANUAL_SIGN,
  PYG_AMT_FOR_TWO_SIGN,
  PYG_MESSAGE--,
  --PYG__IU__CREATE_DATE,
  --PYG__IU__CREATE_USER,
  --PYG__IU__UPDATE_DATE,
  --PYG__IU__UPDATE_USER
FROM PYCOMPAYPRD@conv 
where ppr_comp_code not in ('ZZ')
) loop
INSERT INTO DA.PYCOMPAYPRD@PROD
(  
  PPR_COMP_CODE,
  PPR_PRN_CODE,
  PPR_YEAR,
  PPR_PERIOD,
  PPR_START_DATE,
  PPR_END_DATE,
  PPR_PROCESS_DATE,
  PPR_POSTING_DATE,
  PPR_PAY_DATE,
  PPR_TOTAL_PERIODS,
  PPR_PROCESS_FLAG,
  PPR_MANUAL_OPEN,
  PPR_USER,
  PPR_LAST_UPD_DATE,
  PPR_MONTH--,
  --PPR__IU__CREATE_DATE,
  --PPR__IU__CREATE_USER,
  --PPR__IU__UPDATE_DATE,
  --PPR__IU__UPDATE_USER
)
values
(
i.  PPR_COMP_CODE,
i.    PPR_PRN_CODE,
i.    PPR_YEAR,
i.    PPR_PERIOD,
i.    PPR_START_DATE,
i.    PPR_END_DATE,
i.    PPR_PROCESS_DATE,
i.    PPR_POSTING_DATE,
i.    PPR_PAY_DATE,
i.    PPR_TOTAL_PERIODS,
i.    PPR_PROCESS_FLAG,
i.    PPR_MANUAL_OPEN,
i.    PPR_USER,
i.    PPR_LAST_UPD_DATE,
i.    PPR_MONTH--,
--i.    --PPR__IU__CREATE_DATE,
--i.    --PPR__IU__CREATE_USER,
--i.    --PPR__IU__UPDATE_DATE,
--i.    --PPR__IU__UPDATE_USER
);
end loop;
--commit;
select count(1) into v_cnt_conv from PYCOMPAYPRD@conv;
select count(1) into v_cnt_prod from PYCOMPAYPRD@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for PYCOMPAYPRD table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for PYCOMPAYPRD table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.PYCOMPAYPRD@PROD 
where ppr_comp_code not in ('ZZ');
dbms_output.put_line ('Inserted '||v_cnt||' records into PYCOMPAYPRD table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.PYCOMPAYPRD@PROD.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 