/*
CREATE OR REPLACE VIEW DA1.PERSONNEL_FILE_CADVW(PF_ROW_ORDER, PF_COMP_CODE, PF_PRN_CODE, PF_MONTH_YEAR
                                              , PF_EMP_POS_CODE, PF_EMPNO_SORT, PF_WRL_SORT, PF_LASTNAME_SORT
                                              , PF_HOBTITLE_SORT, PF_EMPLOYEE_NAME, PF_EMP_WRL_CODE
                                              , PF_EMP_WEEKLY_RATE, PF_AMT_LAST_INCR, PF_DATE_OF_INCR
                                              , PF_OT_PAY, PF_RENT_SUPPL, PF_AREA_DIFF, PF_BIRTH_DATE
                                              , PF_HIRE_DATE, PF_EMP_STATUS
                                              )
AS
*/

SELECT 1 ROW_ORDER        
     , PPRD.PPR_COMP_CODE 
     , PPRD.PPR_PRN_CODE
     , TO_CHAR(PPRD.PPR_POSTING_DATE, 'MON') || '-' || PPRD.PPR_YEAR MONTH_YEAR
     , EMP.EMP_WRL_CODE WRL_PARA     
     , NVL(EMP_POS_CODE, 'NULL') EMP_POS_CODE
     
     , EMP.EMP_NO EMPNO_SORT
     , EMP.EMP_WRL_CODE || EMP.EMP_LAST_NAME WRL_SORT
     , TO_NUMBER(EMP.EMP_WRL_CODE) WRL_SORT1
--     , EMP.EMP_LAST_NAME   LASTNAME_SORT1
     , EMP.EMP_LAST_NAME || EMP.EMP_FIRST_NAME LASTNAME_SORT  --First Name is necessary here to avoide grouping in disco desktop
     , INITCAP(EMP.EMP_JOB_TITLE) JOBTITLE_SORT /*|| EMP.EMP_LAST_NAME || EMP.EMP_FIRST_NAME*/ --First Name is necessary here
     
     , EMP.EMP_FIRST_NAME 
     || ' ' || EMP.EMP_MIDDLE_NAME
     || ' ' || EMP.EMP_LAST_NAME          EMPLOYEE_NAME
     , EMP.EMP_WRL_CODE
     , 40 * NVL(ROUND(EMP.EMP_HOURLY_RATE, 2), 0) EMP_WEEKLY_RATE
     , 40 * ROUND(emphist1.rate_diff, 2)          AMT_LAST_INCREASE
     , emphist1.eff_date                          DATE_OF_INCREASE
     , SUM( NVL(ROUND(PHST.TSH_DOT_PAY_AMT, 2), 0) 
          + NVL(ROUND(PHST.TSH_OT_PAY_AMT, 2), 0) 
          + NVL(DECODE(EMPHIST.PHY_TRAN_CODE, 'FOT', ROUND(EMPHIST.PAY_AMT, 2), 0), 0) 
          )                               OT_PAY
     , SUM(DECODE(EMPHIST.PHY_TRAN_CODE, 'RS', ROUND(EMPHIST.PAY_AMT, 2), 0)) RENT_SUPPL
     , SUM(DECODE(EMPHIST.PHY_TRAN_CODE, 'AD', ROUND(EMPHIST.PAY_AMT, 2), 0)) AREA_DIFF
     , TO_CHAR(EMP.EMP_DATE_OF_BIRTH, 'MM-DD-YY') BIRTH_DATE
     , EMP.EMP_HIRE_DATE
     , EMP.EMP_STATUS
FROM DA.PYCOMPAYPRD PPRD
   , DA.PYEMPTIMSHT PHST  
   , DA.PYEMPLOYEE_TABLE EMP
   , (SELECT PHY_COMP_CODE, PHY_PRN_CODE, PHY_PPR_YEAR, PHY_PPR_PERIOD, PHY_EMP_NO 
           , PHY_TRAN_CODE, SUM(PHY_PAY_AMOUNT) PAY_AMT
        FROM DA.PYEMPPAYHIST
       WHERE PHY_TRAN_TYPE = 'BN' 
         AND PHY_TRAN_CODE IN ('RS','AD','FOT' )
      group by PHY_COMP_CODE, PHY_PRN_CODE, PHY_PPR_YEAR, PHY_PPR_PERIOD, PHY_EMP_NO , PHY_TRAN_CODE 
     ) EMPHIST
   , (select prev_emp_no, emh_emp_no, next_emp_no
             , eff_date, emh_seq_no, emh_hour_rate, prev_hour_rate
             , nvl(emh_hour_rate, 0)-nvl(prev_hour_rate, 0) rate_diff, EMH_ACTION_CODE, EMH_ACTION_CODE
        from
            (
             select lag(emh_emp_no, 1, 0) over (order by emh_emp_no, emh_seq_no desc) prev_emp_no
                  , emh_emp_no, next_emp_no
                  , eff_date, emh_seq_no, emh_hour_rate, prev_hour_rate
                  , EMH_ACTION_CODE 
               from
                  (
                   select lag(emh_emp_no, 1, 0) over (order by emh_emp_no desc) prev_emp_no
                        , emh_emp_no
                        , EMH_ACTION_CODE
                        , lead(emh_emp_no, 1, 0) over (order by emh_emp_no, emh_seq_no desc) next_emp_no
                        , emh_effective_date eff_date
                        , emh_seq_no
                        , emh_hour_rate
                        , lead(emh_hour_rate, 1, 0) over (order by emh_emp_no, emh_seq_no desc) prev_hour_rate
                     from da.pyemphist 
--where emh_emp_no in ('01152', '02065', '00390', '01001', '01015', '01017')
--where emh_emp_no = '08296'
                  )
              where emh_hour_rate <> prev_hour_rate
                and emh_emp_no = next_emp_no
                and emh_action_code = 'IN'
            )
              where prev_emp_no <> emh_emp_no
      ) emphist1
WHERE PHST.TSH_COMP_CODE NOT IN ('ZZ')
--AND PHST.TSH_EMP_NO       = '01031'
AND PPRD.PPR_COMP_CODE    = PHST.TSH_COMP_CODE 
AND PPRD.PPR_PRN_CODE     = PHST.TSH_PRN_CODE 
AND PPRD.PPR_YEAR         = PHST.TSH_PPR_YEAR 
AND PPRD.PPR_PERIOD       = PHST.TSH_PPR_PERIOD
AND PHST.TSH_COMP_CODE    = EMPHIST.PHY_COMP_CODE(+)
AND PHST.TSH_PRN_CODE     = EMPHIST.PHY_PRN_CODE(+)
AND PHST.TSH_PPR_YEAR     = EMPHIST.PHY_PPR_YEAR(+)
AND PHST.TSH_PPR_PERIOD   = EMPHIST.PHY_PPR_PERIOD(+)
AND PHST.TSH_EMP_NO       = EMPHIST.PHY_EMP_NO(+)
and PHST.TSH_EMP_NO       = emphist1.emh_emp_no(+)
--AND PHST.TSH_JOB_CODE    >= '90002'
AND EMP.EMP_NO            = PHST.TSH_EMP_NO
GROUP BY EMP.EMP_NO, PPRD.PPR_COMP_CODE, PPRD.PPR_PRN_CODE
       , TO_CHAR(PPRD.PPR_POSTING_DATE, 'MON') || '-' || PPRD.PPR_YEAR
       , EMP.EMP_FIRST_NAME || ' ' || EMP.EMP_MIDDLE_NAME || ' ' || EMP.EMP_LAST_NAME
       , EMP.EMP_WRL_CODE, 40 * NVL(ROUND(EMP.EMP_HOURLY_RATE, 2), 0), EMP.EMP_DATE_OF_BIRTH
       , emphist1.eff_date, 40 * ROUND(emphist1.rate_diff, 2), EMP.EMP_HIRE_DATE
       , EMP.EMP_STATUS, EMP.EMP_JOB_TITLE, EMP.EMP_LAST_NAME, EMP_POS_CODE
       , EMP.EMP_LAST_NAME || EMP.EMP_FIRST_NAME, EMP.EMP_WRL_CODE || EMP.EMP_LAST_NAME
       , INITCAP(EMP.EMP_JOB_TITLE) || EMP.EMP_LAST_NAME || EMP.EMP_FIRST_NAME


UNION ALL

SELECT 2
     , PPRD.PPR_COMP_CODE
     , PPRD.PPR_PRN_CODE
     , TO_CHAR(PPRD.PPR_POSTING_DATE, 'MON') || '-' || PPRD.PPR_YEAR MONTH_YEAR
     , EMP.EMP_WRL_CODE     
     , NVL(EMP_POS_CODE, 'NULL') EMP_POS_CODE
     
     , EMP.EMP_NO EMPNO_SORT
     , EMP.EMP_WRL_CODE || EMP.EMP_LAST_NAME WRL_SORT
     , TO_NUMBER(EMP.EMP_WRL_CODE)     
--     , EMP.EMP_LAST_NAME   LASTNAME_SORT1     
     , EMP.EMP_LAST_NAME || EMP.EMP_FIRST_NAME LASTNAME_SORT  --First Name is necessary here to avoide grouping in disco desktop
     , INITCAP(EMP.EMP_JOB_TITLE) /*|| EMP.EMP_LAST_NAME || EMP.EMP_FIRST_NAME*/ JOBTITLE_SORT --First Name is necessary here
     
     , INITCAP(EMP.EMP_JOB_TITLE)     
     , NULL
     , NULL
     , NULL
     , NULL
     , NULL
     , NULL
     , NULL
     , EMP.EMP_NO
     , EMP.EMP_RE_HIRE_DATE
     , NULL
FROM DA.PYEMPTIMSHT PHST 
   , DA.PYCOMPAYPRD PPRD 
   , DA.PYEMPLOYEE_TABLE EMP
WHERE PHST.TSH_COMP_CODE NOT IN ('ZZ')
--AND PHST.TSH_EMP_NO       = '01031'
AND PPRD.PPR_COMP_CODE    = PHST.TSH_COMP_CODE 
AND PPRD.PPR_PRN_CODE     = PHST.TSH_PRN_CODE 
AND PPRD.PPR_YEAR         = PHST.TSH_PPR_YEAR 
AND PPRD.PPR_PERIOD       = PHST.TSH_PPR_PERIOD
--AND PHST.TSH_JOB_CODE    >= '90002'
AND EMP.EMP_NO            = PHST.TSH_EMP_NO
GROUP BY EMP.EMP_JOB_TITLE, EMP.EMP_NO, EMP.EMP_RE_HIRE_DATE, PPRD.PPR_COMP_CODE
       , PPRD.PPR_PRN_CODE, TO_CHAR(PPRD.PPR_POSTING_DATE, 'MON') || '-' || PPRD.PPR_YEAR
       , EMP.EMP_JOB_TITLE, EMP.EMP_LAST_NAME, EMP.EMP_WRL_CODE, EMP_POS_CODE
       , EMP.EMP_LAST_NAME || EMP.EMP_FIRST_NAME, EMP.EMP_WRL_CODE || EMP.EMP_LAST_NAME 
       , INITCAP(EMP.EMP_JOB_TITLE) || EMP.EMP_LAST_NAME || EMP.EMP_FIRST_NAME      
       
UNION ALL

SELECT 0,NULL,NULL,NULL,NULL,'N/A','N/A',NULL,NULL,NULL,NULL,NULL
      ,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
FROM DUAL      

 
select * from pyemployee where emp_no not in 'NULL'

select * from DA.PYCOMPAYPRD

select * from da.pyemployee

select distinct TSH_PROCESS_FLAG from DA.PYEMPTIMSHT where 

select * from pyemphist where emh_emp_no = '02065'

select * from &p_mastview

select emh_emp_no, emh_action_code from pyemphist where emh_emp_no = '01152'

select prev_emp_no, emh_emp_no, next_emp_no, eff_date, emh_seq_no, emh_hour_rate, prev_hour_rate
, emh_hour_rate-prev_hour_rate rate_diff, EMH_ACTION_CODE, EMH_ACTION_CODE
from
(
select lag(emh_emp_no, 1, 0) over (order by emh_emp_no, emh_seq_no desc) prev_emp_no
, emh_emp_no, next_emp_no, eff_date, emh_seq_no, emh_hour_rate, prev_hour_rate
, EMH_ACTION_CODE 
from
(
select lag(emh_emp_no, 1, 0) over (order by emh_emp_no desc) prev_emp_no
, emh_emp_no
, EMH_ACTION_CODE
, lead(emh_emp_no, 1, 0) over (order by emh_emp_no, emh_seq_no desc) next_emp_no
, emh_effective_date eff_date
, emh_seq_no
, emh_hour_rate
, lead(emh_hour_rate, 1, 0) over (order by emh_emp_no, emh_seq_no desc) prev_hour_rate
from pyemphist 
--where emh_emp_no in ('01152', '02065', '00390', '01001', '01015', '01017')
--where emh_emp_no = '08296'
)
where emh_hour_rate <> prev_hour_rate
and emh_emp_no = next_emp_no
and emh_action_code = 'IN'
)
where prev_emp_no <> emh_emp_no

select emh_emp_no, emh_effective_date, emh_hour_rate from pyemphist where emh_emp_no = '07918'

select * from pyemphist where emh_emp_no = '08296'

select distinct emh_emp_no from pyemphist where emh_action_code = 'IN'

select * from da1.vendor_dirdep_email

select * from jcjobcat where jcat_job_code = '8296' 
and jcat_phs_code like '980%'
and jcat_code = 'S'

SELECT * FROM JCDETAIL WHERE JCDT_JOB_CODE = '90930' AND JCDT_PHS_CODE = '977-00250'

select * from da1.vendor_dirdep_email where upper(vde_email_id) like ('M%')

select tsh_emp_no, TSH_OH_RATE_CODE, TSH_OH_PAY_AMT from PYEMPTIMSHT where TSH_OH_RATE_CODE in ('RS','AD')

select * from PYCOMPAYPRD

SELECT PHY_COMP_CODE, PHY_PRN_CODE, PHY_PPR_YEAR, PHY_PPR_PERIOD, PHY_EMP_NO
           , PHY_TRAN_CODE, SUM(PHY_PAY_AMOUNT) PAY_AMT
        FROM DA.PYEMPPAYHIST
       WHERE PHY_TRAN_TYPE = 'BN'
         AND PHY_TRAN_CODE IN ('RS','AD','FOT' )
group by PHY_COMP_CODE, PHY_PRN_CODE, PHY_PPR_YEAR, PHY_PPR_PERIOD, PHY_EMP_NO , PHY_TRAN_CODE

select * from da1.vendor_dirdep_email

select * from pyemployee

select tsh_emp_no, tsh_nh_pay_rate, emp_no, emp_hourly_rate from
(
select tsh_emp_no, tsh_nh_pay_rate
from pyemptimsht 
where tsh_ppr_year = '2010' and tsh_prn_code = 'WEEK'
group by tsh_emp_no, tsh_nh_pay_rate
),
pyemployee
where tsh_emp_no = emp_no
and tsh_nh_pay_rate <> emp_hourly_rate

EMP_POS_CODE

select tsh_emp_no, count(1) from
(
select tsh_emp_no, tsh_nh_pay_rate
from pyemptimsht 
where tsh_ppr_year = '2010' and tsh_prn_code = 'WEEK'
group by tsh_emp_no, tsh_nh_pay_rate
)
group by tsh_emp_no
order by count(1) desc
   
select * from pyemployee_table where EMP_POS_CODE is not null
