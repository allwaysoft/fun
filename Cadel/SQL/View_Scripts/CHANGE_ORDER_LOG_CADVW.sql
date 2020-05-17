CREATE OR REPLACE FORCE VIEW DA1.CHANGE_ORDER_LOG_CADVW (COL_COMP_CODE, COL_CONT_CODE
                             , COL_CONT_TYPE, COL_VEN_CODE, COL_BP_NAME, COL_CHG_CODE
                             , COL_CONT_AMT, COL_PHS_CODE, COL_POST_DATE, COL_TASK_NAME
                             --, COL_JOB_CODE_NAME
                             , COL_JOB_CODE, COL_JOB_NAME)
AS                             
SELECT  MST2.SCMST_COMP_CODE
      , MST2.SCMST_CONT_CODE
      , MST1.SCMST_CONT_TYPE
      , MST2.SCMST_VEN_CODE
      , PAR.BP_NAME
      , MST2.SCMST_CHG_CODE
      , SUM(NVL(DET.SCDET_CONT_AMT, 0))
      , NVL(DET.SCDET_PHS_CODE,'N/A')
      , Trunc(MST2.SCMST_POST_DATE)
      , NVL(initcap(SCH.SCSCH_TASK_NAME),'N/A')
      --, MST2.SCMST_JOB_CODE ||' - '|| JOB.JOB_NAME
      , MST2.SCMST_JOB_CODE
      , JOB.JOB_NAME
FROM  DA.SCMAST MST1
    , DA.SCMAST MST2
    , DA.SCDETAIL DET 
    , DA.BPARTNERS PAR
    , DA.JCJOB_TABLE JOB
    , (SELECT SCSCH_CHG_CODE,SCSCH_COMP_CODE,
              SCSCH_CONT_CODE,SCSCH_VEN_CODE, 
              MAX(SCSCH_TASK_NAME) SCSCH_TASK_NAME
     FROM DA.SCSCHED 
     GROUP BY SCSCH_CHG_CODE,SCSCH_COMP_CODE,
              SCSCH_CONT_CODE,SCSCH_VEN_CODE
      ) SCH
WHERE MST1.SCMST_CHG_CODE IN ('000')
  AND MST1.SCMST_COMP_CODE NOT IN ('ZZ')
  AND MST1.SCMST_COMP_CODE   = MST2.SCMST_COMP_CODE
  AND MST1.SCMST_VEN_CODE    = MST2.SCMST_VEN_CODE
  AND MST1.SCMST_CONT_CODE   = MST2.SCMST_CONT_CODE
  --AND MST1.SCMST_CHG_CODE    = MST2.SCMST_CHG_CODE
  AND MST2.SCMST_COMP_CODE   = DET.SCDET_COMP_CODE(+)
  AND MST2.SCMST_VEN_CODE    = DET.SCDET_VEN_CODE(+)
  AND MST2.SCMST_CONT_CODE   = DET.SCDET_CONT_CODE(+)
  AND MST2.SCMST_CHG_CODE    = DET.SCDET_CHG_CODE(+)  
  AND MST2.SCMST_VEN_CODE    = PAR.BP_CODE
  AND MST2.SCMST_COMP_CODE   = SCH.SCSCH_COMP_CODE(+)
  AND MST2.SCMST_VEN_CODE    = SCH.SCSCH_VEN_CODE(+)
  AND MST2.SCMST_CONT_CODE   = SCH.SCSCH_CONT_CODE(+)
  AND MST2.SCMST_CHG_CODE    = SCH.SCSCH_CHG_CODE(+)
  AND MST2.SCMST_JOB_CODE    = JOB.JOB_CODE
  AND MST2.SCMST_COMP_CODE   = JOB.JOB_COMP_CODE
  --AND MST2.SCMST_COMP_CODE = '01'
  --AND MST2.SCMST_CONT_CODE ='0113-0001' 
  --AND MST2.SCMST_VEN_CODE = 'COBM001'
  GROUP BY MST2.SCMST_COMP_CODE, MST2.SCMST_CONT_CODE, MST1.SCMST_CONT_TYPE, MST2.SCMST_VEN_CODE
         , PAR.BP_NAME, MST2.SCMST_CHG_CODE, DET.SCDET_PHS_CODE, MST2.SCMST_POST_DATE
         , SCH.SCSCH_TASK_NAME--, MST2.SCMST_JOB_CODE ||' - '|| JOB.JOB_NAME 
         , MST2.SCMST_JOB_CODE, JOB.JOB_NAME
  --ORDER BY MST1.SCMST_CONT_TYPE DESC, MST2.SCMST_CONT_CODE, MST2.SCMST_CHG_CODE
  


update seqnum  set seq_num = '9835' where seq_num = '135' and seq_table_name = 'BATCH'
  select * from seqnum
  commit
  
  select * from seqnum
  
select max(jcbch_num) from jcbatch_table 9834
  
select * from DA1.CHANGE_ORDER_LOG_CADVW  

  
select * from scdetail mst 
where mst.scdet_comp_code = '01'
and mst.scdet_cont_code ='0113-0001' 
and mst.scdet_ven_code = 'COBM001'

select * from scmast mst
where mst.scmst_comp_code = '01'
and mst.scmst_cont_code ='0113-0001' 
and mst.scmst_ven_code = 'COBM001'

select SCh.SCSCH_CHG_CODE,SCh.SCSCH_COMP_CODE,
SCh.SCSCH_CONT_CODE,SCh.SCSCH_VEN_CODE, max(sch.scsch_task_name) scsch_task_name
from scsched sch
group by SCh.SCSCH_CHG_CODE,SCh.SCSCH_COMP_CODE,
SCh.SCSCH_CONT_CODE,SCh.SCSCH_VEN_CODE

having count(1) > 1

select * from scsched 
where SCSCHED.SCSCH_CONT_CODE not in 
(select distinct scmst_cont_code from scmast where scmst_chg_code in '000')

='038' 
and SCSCHED.SCSCH_COMP_CODE = '01'
and SCSCHED.SCSCH_CONT_CODE ='0113-0001' 
and SCSCHED.SCSCH_VEN_CODE = 'COBM001'

from scsched
group by SCSCHED.SCSCH_CHG_CODE,SCSCHED.SCSCH_COMP_CODE,
SCSCHED.SCSCH_CONT_CODE,SCSCHED.SCSCH_VEN_CODE
having count(1) > 1;

SCSCHED.SCSCH_CONT_CODE,SCSCHED.SCSCH_VEN_CODE

group by scmst_cont_code, scmst_ven_code
having count(1) > 1

select * from scmast where scmst_cont_code = '0434-0045'

select * from scsched where  scsch_cont_code = '0823-0002'

select mst.scmst_comp_code   , sch.SCSCH_COMP_CODE
  , mst.scmst_ven_code    , sch.SCSCH_VEN_CODE
  , mst.scmst_cont_code   , sch.SCSCH_CONT_CODE
  , mst.scmst_chg_code    , sch.SCSCH_CHG_CODE 
  from scmast mst,scsched sch
where   mst.scmst_comp_code   = sch.SCSCH_COMP_CODE(+)
  and mst.scmst_ven_code    = sch.SCSCH_VEN_CODE(+)
  and mst.scmst_cont_code   = sch.SCSCH_CONT_CODE(+)
  and mst.scmst_chg_code    = sch.SCSCH_CHG_CODE(+)
  and sch.SCSCH_VEN_CODE is null

select t1.bp_code, t2.bp_code, rownum from
(select bp_code from bpartners where rownum <4)  t1,
(select bp_code from bpartners where rownum <4) t2


from bpartners group by bp_code having count(1) > 1

select esg_code, secgrp_user
 FROM (select '00_FIELD' esg_code from dual
       UNION ALL
       select '00_HOMEOFF' esg_code from dual),
      (select 'DA' secgrp_user from dual
       UNION ALL
       select 'ATAYLOR' secgrp_user from dual
       UNION ALL
       select 'MSMITH' secgrp_user from dual       
      )

