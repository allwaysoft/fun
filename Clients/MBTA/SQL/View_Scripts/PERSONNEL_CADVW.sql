SELECT 1 ROW_ORDER
     , PPRD.PPR_COMP_CODE
     , PPRD.PPR_PRN_CODE
     , TO_CHAR(PPRD.PPR_POSTING_DATE, 'MON') || '-' || PPRD.PPR_YEAR MONTH_YEAR
     
     , EMP.EMP_NO
     , EMP.EMP_FIRST_NAME 
     || ' ' || EMP.EMP_MIDDLE_NAME
     || ' ' || EMP.EMP_LAST_NAME          EMPLOYEE_NAME
     , EMP.EMP_WRL_CODE
     , 40 * NVL(EMP.EMP_HOURLY_RATE, 0)
     , 'AMT_LAST_INCREASE '
     , 'DATE OF INCREASE '
     , SUM( NVL(PHST.TSH_DOT_PAY_AMT, 0) 
          + NVL(PHST.TSH_OT_PAY_AMT, 0) 
          + NVL(DECODE(PHST.TSH_OH_RATE_CODE, 'FOT', PHST.TSH_OH_PAY_AMT, 0), 0) 
          )                               OT_PAY
     , SUM(DECODE(PHST.TSH_OH_RATE_CODE, 'RS', TSH_OH_PAY_AMT, 0)) RENT_SUPPL
     , SUM(DECODE(PHST.TSH_OH_RATE_CODE, 'AD', TSH_OH_PAY_AMT, 0)) AREA_DIFF
     , TO_CHAR(EMP.EMP_DATE_OF_BIRTH, 'MM-DD-YY') BIRTH_DATE
     , EMP.EMP_HIRE_DATE
     , EMP.EMP_STATUS
FROM DA.PYEMPTIMSHT PHST 
   , DA.PYCOMPAYPRD PPRD 
   , DA.PYEMPLOYEE_TABLE EMP
   , (SELECT PHY_COMP_CODE, PHY_PRN_CODE, PHY_PPR_YEAR, PHY_PPR_PERIOD, PHY_EMP_NO 
           , PHY_TRAN_CODE, PHY_PAY_AMOUNT
        FROM DA.PYEMPPAYHIST
       WHERE PHY_TRAN_TYPE = 'BN' 
         AND PHY_TRAN_CODE IN ('RS','AD','FOT' )
     )
WHERE PHST.TSH_COMP_CODE NOT IN ('ZZ')
--AND PHST.TSH_EMP_NO       = '01031'
AND PPRD.PPR_COMP_CODE    = PHST.TSH_COMP_CODE 
AND PPRD.PPR_PRN_CODE     = PHST.TSH_PRN_CODE 
AND PPRD.PPR_YEAR         = PHST.TSH_PPR_YEAR 
AND PPRD.PPR_PERIOD       = PHST.TSH_PPR_PERIOD
AND PHST.TSH_JOB_CODE    >= '90002'
AND EMP.EMP_NO            = PHST.TSH_EMP_NO
GROUP BY EMP.EMP_NO, PPRD.PPR_COMP_CODE, PPRD.PPR_PRN_CODE
       , TO_CHAR(PPRD.PPR_POSTING_DATE, 'MON') || '-' || PPRD.PPR_YEAR
       , EMP.EMP_FIRST_NAME || ' ' || EMP.EMP_MIDDLE_NAME || ' ' || EMP.EMP_LAST_NAME
       , EMP.EMP_WRL_CODE, 40 * NVL(EMP.EMP_HOURLY_RATE, 0), 'AMT_LAST_INCREASE '
       , 'DATE OF INCREASE ' , EMP.EMP_DATE_OF_BIRTH
       , EMP.EMP_HIRE_DATE, EMP.EMP_STATUS

UNION ALL

SELECT 2
     , PPRD.PPR_COMP_CODE
     , PPRD.PPR_PRN_CODE
     , TO_CHAR(PPRD.PPR_POSTING_DATE, 'MON') || '-' || PPRD.PPR_YEAR MONTH_YEAR
     
     , EMP.EMP_NO
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
AND PHST.TSH_JOB_CODE    >= '90002'
AND EMP.EMP_NO            = PHST.TSH_EMP_NO
GROUP BY EMP.EMP_JOB_TITLE, EMP.EMP_NO, EMP.EMP_RE_HIRE_DATE, PPRD.PPR_COMP_CODE
       , PPRD.PPR_PRN_CODE, TO_CHAR(PPRD.PPR_POSTING_DATE, 'MON') || '-' || PPRD.PPR_YEAR


select * from pyemployee_table

select distinct TSH_PROCESS_FLAG from DA.PYEMPTIMSHT where 

select * from pyemphist where emh_emp_no = '02065'

select * from &p_mastview

select emh_emp_no, emh_action_code from pyemphist where emh_emp_no = '01152'

select prev_emp_no, emh_emp_no, next_emp_no, eff_date, prev_eff_date, emh_hour_rate, prev_hour_rate
, emh_hour_rate-prev_hour_rate rate_diff
from
(
select prev_emp_no, emh_emp_no, next_emp_no, eff_date, prev_eff_date, emh_hour_rate, prev_hour_rate
from
(
select lag(emh_emp_no, 1, 0) over (order by emh_emp_no asc) prev_emp_no
, emh_emp_no
, lead(emh_emp_no, 1, 0) over (order by emh_emp_no, emh_seq_no desc) next_emp_no
, emh_effective_date eff_date
, lead(emh_effective_date, 1, NULL) over (order by emh_emp_no, emh_seq_no desc) prev_eff_date
, emh_hour_rate
, lead(emh_hour_rate, 1, 0) over (order by emh_emp_no, emh_seq_no desc) prev_hour_rate
from pyemphist 
--where emh_emp_no in ('01152', '02065', '00390', '01001', '01015', '01017')
--where emh_emp_no = '07918'
)
where emh_hour_rate <> prev_hour_rate
and emh_emp_no = next_emp_no
)
where prev_emp_no <> emh_emp_no


select emh_emp_no, emh_effective_date, emh_hour_rate from pyemphist where emh_emp_no = '07918'

select * from pyemphist where emh_emp_no = '07906'

select * from pyemphist where emh_action_code = 'IN'

00390 01001 01015 01017
emh_action_code = 'IN'

select * from da1.vendor_dirdep_email

select * from jcjobcat where jcat_job_code = '90930' 
and jcat_phs_code like '980%'
and jcat_code = 'S'

SELECT * FROM JCDETAIL WHERE JCDT_JOB_CODE = '90930' AND JCDT_PHS_CODE = '977-00250'

select * from da1.vendor_dirdep_email where upper(vde_email_id) like ('M%')

select tsh_emp_no, TSH_OH_RATE_CODE, TSH_OH_PAY_AMT from PYEMPTIMSHT where TSH_OH_RATE_CODE in ('RS','AD')

select * from PYEMPTIMSHT