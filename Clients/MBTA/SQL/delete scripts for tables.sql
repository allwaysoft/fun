

delete from jcdetail where jcdt_comp_code not in ('ZZ')

delete from bpvendors where bpven_bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT')

delete from bpbanks

delete from bpaddresses

delete from jcbatch_table where jcbch_comp_code not in ('ZZ')

delete from jcdetail where jcdt_comp_code not in ('ZZ')

delete from jcjobcat where jcat_comp_code not in ('ZZ')

commit

delete from jcjobhphs where jhp_comp_code not in ('ZZ')

delete from jcmphs where phs_comp_code not in ('CMIC001','ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT','ZZ')

delete from PMPROJECT_TABLE
commit
--delete from da.jcjobsecgrpjob where jsgj_comp_code not in ('ZZ')
--rollback
--select * from jcjobsecgrpjob

--delete from jcset where jcset_comp_code not in ('ZZ')

delete from JCSUBCONTR where jcsbc_comp_code not in ('ZZ')

delete from jcjob_table where job_comp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT','ZZ')

delete from bpcustomers where bpcust_bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT')

delete from bpartners where bp_code not in ('ZZ-ACME','ZZ-HDEPO','ZZ-EANDL','ZZ-CGRP','ZZ-BCBS','ZZ-WMT')

commit







--delete from pyemphist where emh_comp_code not in ('ZZ')

--delete from pyemppayrate

--delete from pyempsalspl where ess_comp_code not in ('ZZ')

--delete from pyemployee_table where emp_comp_code not in ('ZZ')

--delete from pywcbcode WHERE WCC_COMP_CODE not in ('ZZ')

--delete from pytrades where trd_code not in ('ZZ10','ZZ20','ZZ99','ZZ30')

--delete from PYCOMPAYGRP where pyg_comp_code not in ('ZZ')-- export and import back

--delete from babranch  where brn_bank_code not in ('BOA')-- export and import back

--delete from babank where bnk_bank_code not in ('BOA')

--delete from babankacct where bab_comp_code not in ('ZZ')

delete from pychkloc

delete from PYEMPTIMSHT where tsh_comp_code not in ('ZZ')

commit
rollback
delete from conschart where conschart_code not in ('ZZCHART')
delete from account where acc_conschart_code not in ('ZZCHART')
select count(1) from account
commit

select * from pyworkloc where wrl_code = '0726'

select JCDT_JOB_CODE, JCDT_PHS_CODE from dc_jcdetail where JCDT_ACC_CODE is null
select * from jcjobcat
select * from jcjobhphs
select * from bpvendors where bpven_bp_code like '%CMIC%'
select * from bpcustomers
select * from dc_bpbanks
select * from jccat
select * from jcjob_table
select * from bpaddresses
select * from region where upper(reg_code) like 'X%'

commit

select * from all_constraints where constraint_name like '%JCSET_JCJOB%'--'%JCSUBCONTR_JCJOB_FK%'
