
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  BRN_BANK_CODE,
  BRN_BRANCH_CODE,
  BRN_BRANCH_NAME,
  BRN_SHORT_NAME,
  BRN_USER,
  BRN_LAST_UPD_DATE,
  BRN_SADDR_ORASEQ--,
  --BRN__IU__CREATE_DATE,
  --BRN__IU__CREATE_USER,
  --BRN__IU__UPDATE_DATE,
  --BRN__IU__UPDATE_USER
FROM DA.BABRANCH@CONV
where brn_bank_code not in ('BOA')
) loop
INSERT INTO DA.BABRANCH@PROD
(  
  BRN_BANK_CODE,
  BRN_BRANCH_CODE,
  BRN_BRANCH_NAME,
  BRN_SHORT_NAME,
  BRN_USER,
  BRN_LAST_UPD_DATE,
  BRN_SADDR_ORASEQ--,
  --BRN__IU__CREATE_DATE,
  --BRN__IU__CREATE_USER,
  --BRN__IU__UPDATE_DATE,
  --BRN__IU__UPDATE_USER
)
values
(
i.  BRN_BANK_CODE,
i.    BRN_BRANCH_CODE,
i.    BRN_BRANCH_NAME,
i.    BRN_SHORT_NAME,
i.    BRN_USER,
i.    BRN_LAST_UPD_DATE,
i.    BRN_SADDR_ORASEQ--,
--i.    --BRN__IU__CREATE_DATE,
--i.    --BRN__IU__CREATE_USER,
--i.    --BRN__IU__UPDATE_DATE,
--i.    --BRN__IU__UPDATE_USER
);
end loop;
--commit;
select count(1) into v_cnt_conv from BABRANCH@conv;
select count(1) into v_cnt_prod from BABRANCH@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for BABRANCH table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for BABRANCH table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.BABRANCH@PROD where brn_bank_code not in ('BOA');
dbms_output.put_line ('Inserted '||v_cnt||' records into BABRANCH table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.BABRANCH@PROD.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 