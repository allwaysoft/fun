SET SERVEROUTPUT ON
SET VERIFY OFF
SET PAGESIZE 40
SET LINESIZE 5000
SET ARRAYSIZE 1
PROMPT _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
PROMPT _/    THIS SCRIPT WILL REMOVE ALL RECORDS FROM SCMAST, SCDETAIL, AND SCSCHED _/
PROMPT _/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
PROMPT
PROMPT
PROMPT =======================================================================================================================================================================================================================================================

 
-- create table da.scmast_tmp as
-- select * 
--from da.scmast;

--create table da.scsched_tmp as
--select *
--from da.scsched
--where exists (select 'x'
--from da.scmast
--where scsch_comp_code = scmst_comp_code
--and scsch_ven_code = scmst_ven_code
--and scsch_cont_code = scmst_cont_code
--and scsch_job_code = scmst_job_code);

--create table da.scdetail_tmp as
--select *
--from da.scdetail
--where exists (select 'x'
--from da.scmast
--where scdet_comp_code = scmst_comp_code
--and scdet_ven_code = scmst_ven_code
--and scdet_cont_code = scmst_cont_code
--and scdet_job_code = scmst_job_code);

update da.scmast
set scmst_post_date = null;

commit;

delete from da.scsched
 where exists (select 'x'
          from da.scmast
         where scsch_comp_code = scmst_comp_code
           and scsch_ven_code = scmst_ven_code
           and scsch_cont_code = scmst_cont_code
           and scsch_job_code = scmst_job_code)
       and scsch_comp_code not in ('ZZ');

delete from da.scdetail
 where exists (select 'x'
          from da.scmast
         where scdet_comp_code = scmst_comp_code
           and scdet_ven_code = scmst_ven_code
           and scdet_cont_code = scmst_cont_code
           and scdet_job_code = scmst_job_code)
           and scdet_comp_code not in ('ZZ');
delete
from da.scmast
where SCMST_COMP_CODE not in ('ZZ');
