
set linesize 10000;
set pages 0 emb on newp none;
set feedback off;
set echo off;
set trimspool on;
set termout off;
set underline off;

With Temp_Select as
(
select 1 as Col_Id, '"PYG_COMP_CODE","PYG_CODE","PYG_DESCRIPTION","PYG_SHORT_DESC","PYG_BANK_CODE","PYG_BRANCH_CODE","PYG_BANK_ACC_NUMBER","PYG_CR_ACC_CODE","PYG_USER","PYG_LAST_UPD_DATE","PYG_DEPT_CODE","PYG_SIGN_FILE1","PYG_SIGN_FILE2","PYG_COMPANY_LOGO_FILE","PYG_PRINT_ADDRESS_FLAG","PYG_SECURE_FLAG","PYG_AMT_FOR_MANUAL_SIGN","PYG_AMT_FOR_TWO_SIGN","PYG_MESSAGE","PYG__IU__CREATE_DATE","PYG__IU__CREATE_USER","PYG__IU__UPDATE_DATE","PYG__IU__UPDATE_USER"' col_data
from dual
union
SELECT  2 as col_id,'"' ||
  PYG_COMP_CODE|| '","' ||
  PYG_CODE|| '","' ||
  PYG_DESCRIPTION|| '","' ||
  PYG_SHORT_DESC|| '","' ||
  PYG_BANK_CODE|| '","' ||
  PYG_BRANCH_CODE|| '","' ||
  PYG_BANK_ACC_NUMBER|| '","' ||
  PYG_CR_ACC_CODE|| '","' ||
  PYG_USER|| '","' ||
  PYG_LAST_UPD_DATE|| '","' ||
  PYG_DEPT_CODE|| '","' ||
  PYG_SIGN_FILE1|| '","' ||
  PYG_SIGN_FILE2|| '","' ||
  PYG_COMPANY_LOGO_FILE|| '","' ||
  PYG_PRINT_ADDRESS_FLAG|| '","' ||
  PYG_SECURE_FLAG|| '","' ||
  PYG_AMT_FOR_MANUAL_SIGN|| '","' ||
  PYG_AMT_FOR_TWO_SIGN|| '","' ||
  PYG_MESSAGE|| '","' ||
  PYG__IU__CREATE_DATE|| '","' ||
  PYG__IU__CREATE_USER|| '","' ||
  PYG__IU__UPDATE_DATE|| '","' ||
  PYG__IU__UPDATE_USER || '"' as Col_Data
FROM PYCOMPAYGRP 
where pyg_comp_code not in ('ZZ')
) 
Select Temp_Select.Col_Data
from Temp_Select
Order By Temp_Select.Col_id ;  

spool D:\table_exports\pycompaygrp.txt
/

SPOOL OFF