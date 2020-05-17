
select err.company_code, err.bp_code, decode(bp.bp_code,null,'Y','N') bpartners_flag,
decode(nvl(bv.bpven_bp_code,0)-nvl(bv.bpven_comp_code,0),0,'Y','N') bpvendors_flag
from
(
select substr(dcerr_description,instr(dcerr_description,'BPVEN_COMP_CODE')+16,2) company_code,
substr(dcerr_description,instr(dcerr_description,'BPVEN_BP_CODE')+14,
instr(substr(dcerr_description,instr(dcerr_description,'BPVEN_BP_CODE')+14),' ')-1) bp_code
from dc_error
where upper(dcerr_table_name) = 'DC_SCMAST'
group by substr(dcerr_description,instr(dcerr_description,'BPVEN_COMP_CODE')+16,2)
,substr(dcerr_description,instr(dcerr_description,'BPVEN_BP_CODE')+14,
instr(substr(dcerr_description,instr(dcerr_description,'BPVEN_BP_CODE')+14),' ')-1) 
) err,
bpartners bp,
bpvendors bv
where 1=1
and err.bp_code = bp.bp_code(+)
and err.bp_code = bv.bpven_bp_code (+)
and err.company_code = bv.bpven_comp_code (+)
and (bp.bp_code is null or (bv.bpven_bp_code is null and bv.bpven_comp_code is null))




