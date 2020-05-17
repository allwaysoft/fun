select * from dc_import_status
where upper(dcis_table_code) = 'DC_BPVENDORS'

select max(dcerr_description) from
(
select count(*), dcerr_err_type, dcerr_column_name, dcerr_description 
from dc_error
where upper(dcerr_table_name) = 'DC_VOUDIST'
group by DCERR_err_TYPE, Dcerr_column_name, dcerr_description
)
group by substr(dcerr_description,1,6),substr(reverse(dcerr_description),instr(reverse(dcerr_description),' '),6)


SELECT table_name FROM USER_TAB_columnS 
WHERE column_name='ACC_CODE' 

select * from bpbanks

select * from bpartners where bp_code = 'GUIP001'

Record with  BP_CODE UNIT002 does not exist in DA.BPARTNERS_TABLE table.

Account Code 1001.102 is not associated with a bank account for company 18 and department 00.



delete from pychkloc
rollback
@prod
select * from all_tab_cols where column_name like '%CODE%'
select * from all_tab_cols where column_name like '%FILI%'
select * from all_tables where table_name like '%FILI%'

select EMP_STATE_FILING_STATUS,EMP_CITY_FILING_STATUS from pyemployee_table where EMP_STATE_FILING_STATUS is not null
select * from pyemphist
select * from ACCRUED_TAX_TAX
select * from ACCRUED_TAX_DOCUMENT
select EMP_STATE_FILING_STATUS_DESC from dar.PYEMPHISTPROFILE_V