
set linesize 10000;
set pages 0 emb on newp none;
set feedback off;
set echo off;
set trimspool on;
set termout off;
set underline off;

With Temp_Select as
(
select 1 as Col_Id,'"BRN_BANK_CODE","BRN_BRANCH_CODE","BRN_BRANCH_NAME","BRN_SHORT_NAME","BRN_USER","BRN_LAST_UPD_DATE","BRN_SADDR_ORASEQ","BRN__IU__CREATE_DATE","BRN__IU__CREATE_USER","BRN__IU__UPDATE_DATE","BRN__IU__UPDATE_USER"' Col_Data
from dual 
UNION  
select 2 as col_id,
'"' ||BRN_BANK_CODE
|| '","' ||BRN_BRANCH_CODE
|| '","' ||BRN_BRANCH_NAME
|| '","' ||BRN_SHORT_NAME
|| '","' ||BRN_USER
|| '",' ||BRN_LAST_UPD_DATE
|| ',"' ||BRN_SADDR_ORASEQ
|| '",' ||BRN__IU__CREATE_DATE
|| ',"' ||BRN__IU__CREATE_USER
|| '",' ||BRN__IU__UPDATE_DATE
|| ',"' ||BRN__IU__UPDATE_USER || '"' as Col_Data
from BABRANCH
WHERE brn_bank_code not in ('BOA')
) 
Select Temp_Select.Col_Data
from Temp_Select
Order By Temp_Select.Col_id ;  

spool D:\table_exports\babranch.txt
/

SPOOL OFF