
set linesize 10000;
set pages 0 emb on newp none;
set feedback off;
set echo off;
set trimspool on;
set termout off;
set underline off;

With Temp_Select as
(
select 1 as Col_Id,'"REG_CODE","REG_NAME","REG__IU__CREATE_DATE","REG__IU__CREATE_USER","REG__IU__UPDATE_DATE","REG__IU__UPDATE_USER"' Col_Data
from dual 
UNION  
select 2 as col_id,
       '"' ||r.REG_CODE
|| '","' ||r.REG_NAME
|| '","' ||r.REG__IU__CREATE_DATE
|| '","' ||r.REG__IU__CREATE_USER
|| '","' ||r.REG__IU__UPDATE_DATE
|| '","' ||r.REG__IU__UPDATE_USER as Col_Data
from region r, bpartners_table, bpvendors 
where reg_code = bp_region_code (+)
and reg_code = bpven_pay_region_code (+)
and bp_region_code is null
and bpven_pay_region_code is null
 ) 
Select Temp_Select.Col_Data
from temp_Select
Order By Temp_Select.Col_id ;  

spool C:\tables_date\region.txt
/

spool off

/*
insert into da.region(reg_code)
select bp_code from
(
select dcerr_description,
substr(dcerr_description,instr(dcerr_description,'Region code')+12,
instr(substr(dcerr_description,instr(dcerr_description,'Region code')+12),' ')-1) bp_code
from dc_error
where upper(dcerr_table_name) = 'DC_BPARTNERS'
and substr(dcerr_description,instr(dcerr_description,'Region code')+12,
instr(substr(dcerr_description,instr(dcerr_description,'Region code')+12),' ')-1) is not null
group by dcerr_description,substr(dcerr_description,instr(dcerr_description,'Region code')+12,
instr(substr(dcerr_description,instr(dcerr_description,'Region code')+12),' ')-1) 
)
*/