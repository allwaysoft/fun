
declare

v_cnt      NUMBER;
v_cnt_conv NUMBER;
v_cnt_prod NUMBER;
record_count_mismatch exception;

begin
for i in
(
SELECT 
  BNK_BANK_CODE,
  BNK_BANK_NAME,
  BNK_SHORT_NAME,
  BNK_USER,
  BNK_LAST_UPD_DATE,
  BNK_EXCHG_PROG,
  BNK_STMT_PROG,
  BNK_PAYORDERS_PROG,
  BNK_COUNTRY_CODE,
  BNK_SWIFT,
  BNK_ACTIVE_FLAG,
  BNK_JRNL_CODE,
  BNK_EXCHG_FILE_NAME,
  BNK_STMT_FILE_NAME,
  BNK_PAYORDERS_FILE_NAME,
  BNK_CREATE_USER,
  BNK_CREATE_DATE,
  BNK_LAST_UPD_USER,
  BNK_ALT_CODE,
  BNK_ROUTING_CODE,
  BNK_ACH_LOGON_TEXT,
  BNK_ACC_NUM_FORMAT_FLAG,
  BNK_BANK_ID,
  BNK_PASSWORD--,
  --BNK__IU__CREATE_DATE,
  --BNK__IU__CREATE_USER,
  --BNK__IU__UPDATE_DATE,
  --BNK__IU__UPDATE_USER
FROM DA.BABANK@CONV
WHERE BNK_BANK_CODE NOT IN ('BOA')
) loop
INSERT INTO DA.BABANK
(  
  BNK_BANK_CODE,
  BNK_BANK_NAME,
  BNK_SHORT_NAME,
  BNK_USER,
  BNK_LAST_UPD_DATE,
  BNK_EXCHG_PROG,
  BNK_STMT_PROG,
  BNK_PAYORDERS_PROG,
  BNK_COUNTRY_CODE,
  BNK_SWIFT,
  BNK_ACTIVE_FLAG,
  BNK_JRNL_CODE,
  BNK_EXCHG_FILE_NAME,
  BNK_STMT_FILE_NAME,
  BNK_PAYORDERS_FILE_NAME,
  BNK_CREATE_USER,
  BNK_CREATE_DATE,
  BNK_LAST_UPD_USER,
  BNK_ALT_CODE,
  BNK_ROUTING_CODE,
  BNK_ACH_LOGON_TEXT,
  BNK_ACC_NUM_FORMAT_FLAG,
  BNK_BANK_ID,
  BNK_PASSWORD--,
  --BNK__IU__CREATE_DATE,
  --BNK__IU__CREATE_USER,
  --BNK__IU__UPDATE_DATE,
  --BNK__IU__UPDATE_USER
)
values
(
i.  BNK_BANK_CODE,
i.  BNK_BANK_NAME,
i.  BNK_SHORT_NAME,
i.  BNK_USER,
i.  BNK_LAST_UPD_DATE,
i.  BNK_EXCHG_PROG,
i.  BNK_STMT_PROG,
i.  BNK_PAYORDERS_PROG,
i.  BNK_COUNTRY_CODE,
i.  BNK_SWIFT,
i.  BNK_ACTIVE_FLAG,
i.  BNK_JRNL_CODE,
i.  BNK_EXCHG_FILE_NAME,
i.  BNK_STMT_FILE_NAME,
i.  BNK_PAYORDERS_FILE_NAME,
i.  BNK_CREATE_USER,
i.  BNK_CREATE_DATE,
i.  BNK_LAST_UPD_USER,
i.  BNK_ALT_CODE,
i.  BNK_ROUTING_CODE,
i.  BNK_ACH_LOGON_TEXT,
i.  BNK_ACC_NUM_FORMAT_FLAG,
i.  BNK_BANK_ID,
i.  BNK_PASSWORD--,
--i.  --BNK__IU__CREATE_DATE,
--i.  --BNK__IU__CREATE_USER,
--i.  --BNK__IU__UPDATE_DATE,
--i.  --BNK__IU__UPDATE_USER
);
end loop;
--commit;
select count(1) into v_cnt_conv from BABANK@conv;
select count(1) into v_cnt_prod from BABANK@prod;
if v_cnt_conv - v_cnt_prod = 0
then
dbms_output.put_line ('Number of records in PROD match with CONV for BABANK table.');
else
dbms_output.put_line ('Number of records in PROD does not match with CONV for BABANK table.');
Raise record_count_mismatch;
end if;
Select count(1) into v_cnt from DA.BABANK@PROD where BNK_BANK_CODE NOT IN ('BOA');
dbms_output.put_line ('Inserted '||v_cnt||' records into BABANK table, check and commit.');
EXCEPTION
WHEN record_count_mismatch
THEN
DBMS_OUTPUT.PUT_LINE ('There is a mismatch in PROD and CONV for this table.');
WHEN OTHERS 
THEN
DBMS_OUTPUT.PUT_LINE ('ERROR WHILE INSERTING INTO DA.BABANK.');
DBMS_OUTPUT.PUT_LINE (SQLERRM);

end;
/ 