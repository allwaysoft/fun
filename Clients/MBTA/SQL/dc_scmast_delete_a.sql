SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGESIZE 40
SET LINESIZE 5000
SET ARRAYSIZE 1
CLEAR SCREEN
PROMPT _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
PROMPT _/    THIS SCRIPT WILL REMOVE RECORDS FROM SCMAST, SCDETAIL, AND SCSCHED _/
PROMPT _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
PROMPT
PROMPT
PROMPT =======================================================================================================================================================================================================================================================
PROMPT
UNDEFINE COMPANY_CODE
UNDEFINE VENDOR_CODE
UNDEFINE CONTRACT_CODE
UNDEFINE JOB_CODE
DEFINE C_COMP_CODE  = &&COMPANY_CODE
DEFINE C_VEN_CODE   = &&VENDOR_CODE
DEFINE C_CONT_CODE  = &&CONTRACT_CODE
DEFINE C_JOB_CODE   = &&JOB_CODE
PROMPT
PROMPT =======================================================================================================================================================================================================================================================

update da.scmast
set scmst_post_date = null
where scmst_comp_code = UPPER('&&C_COMP_CODE')
and   scmst_ven_code = UPPER('&&C_VEN_CODE')
and   scmst_job_code = UPPER('&&C_JOB_CODE')
and   scmst_cont_code = UPPER('&&C_CONT_CODE');

commit;

delete
from da.scdetail
where scdet_comp_code = UPPER('&&C_COMP_CODE')
and   scdet_ven_code = UPPER('&&C_VEN_CODE')
and   scdet_cont_code = UPPER('&&C_CONT_CODE')
and   scdet_job_code = UPPER('&&C_JOB_CODE');

delete
from da.scsched
where scsch_comp_code = UPPER('&&C_COMP_CODE')
and   scsch_ven_code = UPPER('&&C_VEN_CODE')
and   scsch_cont_code = UPPER('&&C_CONT_CODE')
and   scsch_job_code = UPPER('&&C_JOB_CODE');

delete
from da.scmast
where scmst_comp_code = UPPER('&&C_COMP_CODE')
and   scmst_ven_code = UPPER('&&C_VEN_CODE')
and   scmst_job_code = UPPER('&&C_JOB_CODE')
and   scmst_cont_code = UPPER('&&C_CONT_CODE');

commit;


