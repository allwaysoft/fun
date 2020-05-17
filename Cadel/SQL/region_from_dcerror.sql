
SET VERIFY OFF 
SET serveroutput on size 1000000

accept in_which_database prompt 'Insert to which database:'
accept dcerror_frm_which_DB prompt 'Insert from dcerror table of which database:'

insert into da.region@&in_which_database(reg_code)
select bp_code from
(
select dcerr_description,
substr(dcerr_description,instr(dcerr_description,'Region code')+12,
instr(substr(dcerr_description,instr(dcerr_description,'Region code')+12),' ')-1) bp_code
from dc_error@&dcerror_frm_which_DB
where upper(dcerr_table_name) = 'DC_BPARTNERS'
and substr(dcerr_description,instr(dcerr_description,'Region code')+12,
instr(substr(dcerr_description,instr(dcerr_description,'Region code')+12),' ')-1) is not null
group by dcerr_description,substr(dcerr_description,instr(dcerr_description,'Region code')+12,
instr(substr(dcerr_description,instr(dcerr_description,'Region code')+12),' ')-1) 
)
/