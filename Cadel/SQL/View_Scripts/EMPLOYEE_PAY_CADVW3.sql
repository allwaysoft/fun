-- Below view is for the Employee Pay Report (DIS007A)
CREATE OR REPLACE VIEW DA1.EMPLOYEE_PAY_CADVW (EPC_ROW_ORDER, EPC_START_DATE, EPC_END_DATE
                                             , EPC_EMP_NO1, EPC_COMP_CODE, EPC_LAST_NAME 
                                             , EPC_PRN_CODE, EPC_PROCESS_FLAG, EPC_APRV_STATUS
                                             , EPC_EMP_NO2, EPC_PERIOD, EPC_LNAME_TSH_NH_RATE_CODE
                                             , EPC_SHIFT_CODE, EPC_FNAME_TSH_DATE
                                             , EPC_MNAME_TSH_COMP_CODE, EPC_JOB_CODE, EPC_PHASE
                                             , EPC_CATEGORY, EPC_WORK_LOCATION, EPC_TRADE_CODE
                                             , EPC_NORMAL_HOURS, EPC_NH_PAY_RATE, EPC_NH_PAY_AMT
                                             , EPC_WCB_CODE
                                              ) 
AS 

SELECT ROW_ORDER, PPR_START_DATE, PPR_END_DATE, TSH_EMP_NO1, TSH_COMP_CODE, EMP_LAST_NAME
     , TSH_PRN_CODE, TSH_PROCESS_FLAG, TSH_APRV_STATUS, TSH_EMP_NO2, PPR_PERIOD
     , EMP_LNAME_TSH_NH_RATE_CODE, TSH_SHIFT_CODE, EMP_FNAME_TSH_DATE, EMP_MNAME_TSH_COMP_CODE
     , TSH_JOB_CODE, TSH_PHASE, TSH_CATEGORY, TSH_WORK_LOCATION, TSH_TRADE_CODE
     , TSH_NORMAL_HOURS, TSH_NH_PAY_RATE, TSH_NH_PAY_AMT, TSH_WCB_CODE
FROM     
(
(
SELECT 1                                                 ROW_ORDER
     , /*TO_DATE(*/PPRD.PPR_START_DATE/*,'YYYY-MM-DD')*/         PPR_START_DATE
     , /*TO_DATE(*/PPRD.PPR_END_DATE/*,'YYYY-MM-DD')*/           PPR_END_DATE
     , EMP.EMP_NO                                        TSH_EMP_NO1
     , PPRD.PPR_COMP_CODE                                TSH_COMP_CODE
     , UPPER(EMP.EMP_LAST_NAME)                          EMP_LAST_NAME
     , PHST.TSH_PRN_CODE                                 TSH_PRN_CODE     
     , PHST.TSH_PROCESS_FLAG                             TSH_PROCESS_FLAG
     , PHST.TSH_APRV_STATUS                              TSH_APRV_STATUS 
     
     , 'EMP NO:' || EMP.EMP_NO                           TSH_EMP_NO2
     , 'EMP NO:' || EMP.EMP_NO                           PPR_PERIOD
     , UPPER(EMP.EMP_LAST_NAME)  || ', '                 EMP_LNAME_TSH_NH_RATE_CODE     
     , NULL                                              TSH_SHIFT_CODE
     , UPPER(EMP.EMP_FIRST_NAME) || ', '                 EMP_FNAME_TSH_DATE
     , UPPER(EMP.EMP_MIDDLE_NAME)                        EMP_MNAME_TSH_COMP_CODE
     , NULL                                              TSH_JOB_CODE   
     , NULL                                              TSH_PHASE       
     , NULL                                              TSH_CATEGORY
     , PHST.TSH_WORK_LOCATION                            TSH_WORK_LOCATION
     , NULL                                              TSH_TRADE_CODE
     , NULL                                              TSH_NORMAL_HOURS
     , NULL                                              TSH_NH_PAY_RATE
     , NULL                                              TSH_NH_PAY_AMT
     , NULL                                              TSH_WCB_CODE
FROM DA.PYEMPTIMSHT PHST 
   , DA.PYCOMPAYPRD PPRD 
   , DA.PYEMPLOYEE_TABLE EMP
WHERE PHST.TSH_COMP_CODE NOT IN ('ZZ')
AND PHST.TSH_JOB_CODE   >= '90002'
AND PHST.TSH_PRN_CODE    = 'WEEK'
AND PPRD.PPR_COMP_CODE   = PHST.TSH_COMP_CODE
AND PPRD.PPR_PRN_CODE    = PHST.TSH_PRN_CODE
AND PPRD.PPR_YEAR        = PHST.TSH_PPR_YEAR
AND PPRD.PPR_PERIOD      = PHST.TSH_PPR_PERIOD
AND EMP.EMP_NO           = PHST.TSH_EMP_NO
--AND EMP.EMP_NO           = '12049' 
AND NVL(PHST.TSH_NH_PAY_AMT, 0) 
  + NVL(PHST.TSH_OT_PAY_AMT, 0)
  + NVL(PHST.TSH_DOT_PAY_AMT, 0)
  + NVL(PHST.TSH_OH_PAY_AMT, 0) <> 0 
GROUP BY PPRD.PPR_START_DATE, PPRD.PPR_END_DATE, EMP.EMP_NO, PPRD.PPR_COMP_CODE
       , EMP.EMP_FIRST_NAME, EMP.EMP_LAST_NAME, EMP.EMP_MIDDLE_NAME, EMP.EMP_LAST_NAME
       , PHST.TSH_PRN_CODE, PHST.TSH_PROCESS_FLAG, PHST.TSH_WORK_LOCATION, PPRD.PPR_COMP_CODE
       , PHST.TSH_APRV_STATUS, PHST.TSH_JOB_CODE

UNION

SELECT 1                                                 
     , PPRD.PPR_START_DATE                               
     , PPRD.PPR_END_DATE                                 
     , EMP.EMP_NO                                        
     , PPRD.PPR_COMP_CODE                                
     , UPPER(EMP.EMP_LAST_NAME)                          
     , SADJ.SAD_PRN_CODE                                 
     , SADJ.SAD_PROCESS_FLAG                             
     , NULL                             
     
     , 'EMP NO:' || EMP.EMP_NO                           
     , 'EMP NO:' || EMP.EMP_NO                           
     , UPPER(EMP.EMP_LAST_NAME)  || ', '                    
     , NULL                                              
     , UPPER(EMP.EMP_FIRST_NAME) || ', '                   
     , UPPER(EMP.EMP_MIDDLE_NAME)                        
     , NULL                                              
     , NULL                                              
     , NULL                                              
     , SADJ.SAD_WRL_CODE                                 
     , NULL                                              
     , NULL                                              
     , NULL                                              
     , NULL                                              
     , NULL                                              
FROM DA.PYEMPSALADJ SADJ
   , DA.PYCOMPAYPRD PPRD  
   , DA.PYEMPTIMSHT PHST
   , DA.PYEMPLOYEE_TABLE EMP    
WHERE SADJ.SAD_COMP_CODE  NOT IN ('ZZ')
AND NVL(SADJ.SAD_AMOUNT, 0) <> 0 
AND SADJ.SAD_JOB       >= '90002'
AND PHST.TSH_PRN_CODE   = 'WEEK'
AND PPRD.PPR_COMP_CODE = SADJ.SAD_COMP_CODE   
AND PPRD.PPR_PRN_CODE  = SADJ.SAD_PRN_CODE   
AND PPRD.PPR_YEAR      = SADJ.SAD_PPR_YEAR   
AND PPRD.PPR_PERIOD    = SADJ.SAD_PPR_PERIOD
AND PPRD.PPR_COMP_CODE = PHST.TSH_COMP_CODE  (+)
AND PPRD.PPR_PRN_CODE  = PHST.TSH_PRN_CODE   (+)
AND PPRD.PPR_YEAR      = PHST.TSH_PPR_YEAR   (+)
AND PPRD.PPR_PERIOD    = PHST.TSH_PPR_PERIOD (+)
AND EMP.EMP_NO         = SADJ.SAD_EMP_NO
--AND EMP.EMP_NO           = '12049' 
AND (PHST.TSH_COMP_CODE IS NULL 
     AND PHST.TSH_PRN_CODE IS NULL 
     AND PHST.TSH_PPR_YEAR IS NULL 
     AND PHST.TSH_PPR_PERIOD IS NULL
    )
GROUP BY PPRD.PPR_START_DATE, PPRD.PPR_END_DATE, EMP.EMP_NO, PPRD.PPR_COMP_CODE
     , EMP.EMP_FIRST_NAME, EMP.EMP_LAST_NAME, EMP.EMP_MIDDLE_NAME, EMP.EMP_LAST_NAME
     , SADJ.SAD_PRN_CODE, SADJ.SAD_PROCESS_FLAG, SADJ.SAD_WRL_CODE, PPRD.PPR_COMP_CODE
     , SADJ.SAD_JOB
)     

UNION ALL

SELECT 2

     , PPRD.PPR_START_DATE
     , PPRD.PPR_END_DATE
     , PHST.TSH_EMP_NO
     , PHST.TSH_COMP_CODE
     , UPPER(EMP.EMP_LAST_NAME)
     , PHST.TSH_PRN_CODE                
     , PHST.TSH_PROCESS_FLAG            
     , PHST.TSH_APRV_STATUS
     
     , 'EMP NO:' || PHST.TSH_EMP_NO
     , TO_CHAR(PPRD.PPR_PERIOD )
     , TO_CHAR(PHST.TSH_DATE, 'MM-DD-YY')
     , PHST.TSH_SHIFT_CODE
     , PHST.TSH_NH_RATE_CODE
     , PHST.TSH_COMP_CODE
     , PHST.TSH_JOB_CODE
     , PHST.TSH_PHASE
     , PHST.TSH_CATEGORY
     , PHST.TSH_WORK_LOCATION
     , PHST.TSH_TRADE_CODE
     , PHST.TSH_NORMAL_HOURS
     , PHST.TSH_NH_PAY_RATE
     , PHST.TSH_NH_PAY_AMT
     , PHST.TSH_WCB_CODE
FROM DA.PYEMPTIMSHT PHST 
   , DA.PYCOMPAYPRD PPRD 
   , DA.PYEMPLOYEE_TABLE EMP
WHERE PHST.TSH_COMP_CODE NOT IN ('ZZ')
AND NVL(PHST.TSH_NH_PAY_AMT, 0)  <> 0
--AND PHST.TSH_EMP_NO       = '12049'
AND PPRD.PPR_COMP_CODE = PHST.TSH_COMP_CODE 
AND PPRD.PPR_PRN_CODE  = PHST.TSH_PRN_CODE 
AND PPRD.PPR_YEAR      = PHST.TSH_PPR_YEAR 
AND PPRD.PPR_PERIOD    = PHST.TSH_PPR_PERIOD
AND PHST.TSH_JOB_CODE >= '90002'
AND PHST.TSH_PRN_CODE  = 'WEEK'
AND EMP.EMP_NO         = PHST.TSH_EMP_NO

UNION ALL

SELECT 3

     , PPRD.PPR_START_DATE
     , PPRD.PPR_END_DATE
     , PHST.TSH_EMP_NO
     , PHST.TSH_COMP_CODE
     , UPPER(EMP.EMP_LAST_NAME)     
     , PHST.TSH_PRN_CODE                
     , PHST.TSH_PROCESS_FLAG       
     , PHST.TSH_APRV_STATUS
     
     , 'EMP NO:' || PHST.TSH_EMP_NO
     , TO_CHAR(PPRD.PPR_PERIOD) 
     , TO_CHAR(PHST.TSH_DATE, 'MM-DD-YY')
     , PHST.TSH_SHIFT_CODE
     , PHST.TSH_OT_RATE_CODE
     , PHST.TSH_COMP_CODE
     , PHST.TSH_JOB_CODE
     , PHST.TSH_PHASE
     , PHST.TSH_CATEGORY
     , PHST.TSH_WORK_LOCATION
     , PHST.TSH_TRADE_CODE
     , PHST.TSH_OT_HOURS
     , PHST.TSH_OT_PAY_RATE
     , PHST.TSH_OT_PAY_AMT
     , PHST.TSH_WCB_CODE
FROM DA.PYEMPTIMSHT PHST 
   , DA.PYCOMPAYPRD PPRD 
   , DA.PYEMPLOYEE_TABLE EMP
WHERE PHST.TSH_COMP_CODE NOT IN ('ZZ')
AND NVL(PHST.TSH_OT_PAY_AMT, 0)  <> 0
--AND PHST.TSH_EMP_NO       = '12049'
AND PPRD.PPR_COMP_CODE = PHST.TSH_COMP_CODE 
AND PPRD.PPR_PRN_CODE  = PHST.TSH_PRN_CODE 
AND PPRD.PPR_YEAR      = PHST.TSH_PPR_YEAR 
AND PPRD.PPR_PERIOD    = PHST.TSH_PPR_PERIOD
AND PHST.TSH_JOB_CODE >= '90002'
AND PHST.TSH_PRN_CODE  = 'WEEK'
AND EMP.EMP_NO         = PHST.TSH_EMP_NO
 
UNION ALL

SELECT 4
     , PPRD.PPR_START_DATE
     , PPRD.PPR_END_DATE
     , PHST.TSH_EMP_NO
     , PHST.TSH_COMP_CODE
     , UPPER(EMP.EMP_LAST_NAME)
     , PHST.TSH_PRN_CODE                
     , PHST.TSH_PROCESS_FLAG       
     , PHST.TSH_APRV_STATUS
     
     , 'EMP NO:' || PHST.TSH_EMP_NO
     , TO_CHAR(PPRD.PPR_PERIOD) 
     , TO_CHAR(PHST.TSH_DATE, 'MM-DD-YY')
     , PHST.TSH_SHIFT_CODE
     , PHST.TSH_DOT_RATE_CODE
     , PHST.TSH_COMP_CODE
     , PHST.TSH_JOB_CODE
     , PHST.TSH_PHASE
     , PHST.TSH_CATEGORY
     , PHST.TSH_WORK_LOCATION
     , PHST.TSH_TRADE_CODE
     , PHST.TSH_DOT_HOURS
     , PHST.TSH_DOT_PAY_RATE
     , PHST.TSH_DOT_PAY_AMT
     , PHST.TSH_WCB_CODE
FROM DA.PYEMPTIMSHT PHST 
   , DA.PYCOMPAYPRD PPRD 
   , DA.PYEMPLOYEE_TABLE EMP
WHERE PHST.TSH_COMP_CODE NOT IN ('ZZ')
AND NVL(PHST.TSH_DOT_PAY_AMT, 0) <> 0
--AND PHST.TSH_EMP_NO       = '12049'
AND PPRD.PPR_COMP_CODE = PHST.TSH_COMP_CODE 
AND PPRD.PPR_PRN_CODE  = PHST.TSH_PRN_CODE 
AND PPRD.PPR_YEAR      = PHST.TSH_PPR_YEAR 
AND PPRD.PPR_PERIOD    = PHST.TSH_PPR_PERIOD
AND PHST.TSH_JOB_CODE >= '90002'
AND PHST.TSH_PRN_CODE  = 'WEEK'
AND EMP.EMP_NO         = PHST.TSH_EMP_NO

UNION ALL

SELECT 5
     , PPRD.PPR_START_DATE
     , PPRD.PPR_END_DATE
     , PHST.TSH_EMP_NO
     , PHST.TSH_COMP_CODE
     , UPPER(EMP.EMP_LAST_NAME)
     , PHST.TSH_PRN_CODE                
     , PHST.TSH_PROCESS_FLAG       
     , PHST.TSH_APRV_STATUS
     
     , 'EMP NO:' || PHST.TSH_EMP_NO
     , TO_CHAR(PPRD.PPR_PERIOD)
     , TO_CHAR(PHST.TSH_DATE, 'MM-DD-YY')
     , PHST.TSH_SHIFT_CODE
     , PHST.TSH_OH_RATE_CODE
     , PHST.TSH_COMP_CODE
     , PHST.TSH_JOB_CODE
     , PHST.TSH_PHASE
     , PHST.TSH_CATEGORY
     , PHST.TSH_WORK_LOCATION
     , PHST.TSH_TRADE_CODE
     , PHST.TSH_OTHER_HOURS
     , PHST.TSH_OH_PAY_RATE
     , PHST.TSH_OH_PAY_AMT
     , PHST.TSH_WCB_CODE
FROM DA.PYEMPTIMSHT PHST 
   , DA.PYCOMPAYPRD PPRD 
   , DA.PYEMPLOYEE_TABLE EMP
WHERE PHST.TSH_COMP_CODE NOT IN ('ZZ')
AND NVL(PHST.TSH_OH_PAY_AMT, 0) <> 0
--AND PHST.TSH_EMP_NO       = '12049'
AND PPRD.PPR_COMP_CODE = PHST.TSH_COMP_CODE 
AND PPRD.PPR_PRN_CODE  = PHST.TSH_PRN_CODE 
AND PPRD.PPR_YEAR      = PHST.TSH_PPR_YEAR 
AND PPRD.PPR_PERIOD    = PHST.TSH_PPR_PERIOD
AND PHST.TSH_JOB_CODE >= '90002'
AND PHST.TSH_PRN_CODE  = 'WEEK'
AND EMP.EMP_NO         = PHST.TSH_EMP_NO

UNION ALL

SELECT 6
     , PPRD.PPR_START_DATE
     , PPRD.PPR_END_DATE
     , SADJ.SAD_EMP_NO
     , SADJ.SAD_COMP_CODE
     , UPPER(EMP.EMP_LAST_NAME)
     , SADJ.SAD_PRN_CODE                
     , SADJ.SAD_PROCESS_FLAG      
     , NULL
     
     , 'EMP NO:' || SADJ.SAD_EMP_NO
     , TO_CHAR(PPRD.PPR_PERIOD) 
     , TO_CHAR(PPRD.PPR_END_DATE, 'MM-DD-YY')
     , NULL --SADJ.SAD_SHIFT_CODE
     , SADJ.SAD_RATE_CODE
     , SADJ.SAD_COMP_CODE
     , SADJ.SAD_JOB
     , SADJ.SAD_PHASE
     , SADJ.SAD_CATEGORY
     , SADJ.SAD_WRL_CODE
     , SADJ.SAD_TRADE_CODE
     , NULL --SADJ.SAD_OTHER_HOURS
     , NULL --SADJ.SAD_OH_PAY_RATE
     , SADJ.SAD_AMOUNT
     , SADJ.SAD_WCB_CODE
FROM DA.PYEMPSALADJ SADJ 
   , DA.PYCOMPAYPRD PPRD 
   , DA.PYEMPLOYEE_TABLE EMP
WHERE SADJ.SAD_COMP_CODE NOT IN ('ZZ')
AND NVL(SADJ.SAD_AMOUNT, 0) <> 0
--AND SADJ.SAD_EMP_NO       = '12049'
AND PPRD.PPR_COMP_CODE = SADJ.SAD_COMP_CODE 
AND PPRD.PPR_PRN_CODE  = SADJ.SAD_PRN_CODE 
AND PPRD.PPR_YEAR      = SADJ.SAD_PPR_YEAR 
AND PPRD.PPR_PERIOD    = SADJ.SAD_PPR_PERIOD
AND SADJ.SAD_JOB      >= '90002'
AND SADJ.SAD_PRN_CODE  = 'WEEK'
AND EMP.EMP_NO         = SADJ.SAD_EMP_NO
)
ORDER BY TSH_EMP_NO1, ROW_ORDER







-- Below SQL is for Employee Pay Summary Report (DIS007B)
SELECT DISTINCT 1                  ROW_ORDER1
     , NULL                        ROW_ORDER2
     , NULL                        ROW_ORDER3
     , EPC_START_DATE              START_DATE
     , EPC_END_DATE                END_DATE
     , EPC_EMP_NO1                 EMP_NO
     , EPC_COMP_CODE               COMP_CODE
     , 'TOTAL EMPLOYEES: '         GROUP_BY_TYPE
     , 1                           TOT_HRS
     , NULL                        TOT_AMT
     
     , EPC_LAST_NAME
     , EPC_PRN_CODE                
     , EPC_PROCESS_FLAG       
     , EPC_APRV_STATUS
     , EPC_WORK_LOCATION     
FROM DA1.EMPLOYEE_PAY_CADVW
WHERE EPC_ROW_ORDER <> 1

UNION ALL

SELECT 2
     , NULL
     , DECODE(EPC_FNAME_TSH_DATE, 'REG', '21', 'OT', '22', 'OTS', '23', '29'
                                        , NVL(EPC_FNAME_TSH_DATE, '777777777'))
     , EPC_START_DATE
     , EPC_END_DATE
     , EPC_EMP_NO1
     , EPC_COMP_CODE
     , 'TOTAL '|| EPC_FNAME_TSH_DATE || '  HOURS: ' 
     , EPC_NORMAL_HOURS
     , EPC_NH_PAY_AMT
     
     , EPC_LAST_NAME
     , EPC_PRN_CODE                
     , EPC_PROCESS_FLAG       
     , EPC_APRV_STATUS
     , EPC_WORK_LOCATION     
FROM DA1.EMPLOYEE_PAY_CADVW
WHERE EPC_ROW_ORDER <> 1
--GROUP BY 'TOTAL '|| EPC_LNAME_TSH_NH_RATE_CODE || '  HOURS:' 

UNION ALL

SELECT 3
     , NVL(EPC_SHIFT_CODE, 888888888)
     , DECODE(EPC_FNAME_TSH_DATE, 'REG', '31', 'OT', '32', 'OTS', '33'
                                        , NVL(EPC_FNAME_TSH_DATE, '88888888'))
     , EPC_START_DATE                 
     , EPC_END_DATE                   
     , EPC_EMP_NO1                    
     , EPC_COMP_CODE                  
     , 'SUBTOTAL SHIFT '                
       || NVL(EPC_SHIFT_CODE, 'N/A') 
       || ' ' 
       ||EPC_FNAME_TSH_DATE
       || ' HOURS:'                   
     , EPC_NORMAL_HOURS                  
     , EPC_NH_PAY_AMT
     
     , EPC_LAST_NAME
     , EPC_PRN_CODE                
     , EPC_PROCESS_FLAG       
     , EPC_APRV_STATUS  
     , EPC_WORK_LOCATION     
FROM DA1.EMPLOYEE_PAY_CADVW   
WHERE EPC_ROW_ORDER <> 1
/*
GROUP BY 'SUBTOTAL SHIFT ' 
         || NVL(EPC_SHIFT_CODE, 'N/A') 
         || ' ' 
         ||EPC_LNAME_TSH_NH_RATE_CODE 
         || ' HOURS:'
*/

UNION ALL 

SELECT 4
     , NVL(EPC_SHIFT_CODE, 9999999999) 
     , NULL
     , EPC_START_DATE
     , EPC_END_DATE
     , EPC_EMP_NO1
     , EPC_COMP_CODE     
     , 'TOTAL SHIFT '
       || NVL(EPC_SHIFT_CODE, 'N/A') 
       || ' HOURS:'       
     , EPC_NORMAL_HOURS    
     , EPC_NH_PAY_AMT
     
     , EPC_LAST_NAME
     , EPC_PRN_CODE                
     , EPC_PROCESS_FLAG       
     , EPC_APRV_STATUS  
     , EPC_WORK_LOCATION     
FROM DA1.EMPLOYEE_PAY_CADVW
WHERE EPC_ROW_ORDER <> 1     

UNION ALL

SELECT 5
     , NULL
     , NULL
     , EPC_START_DATE
     , EPC_END_DATE
     , EPC_EMP_NO1
     , EPC_COMP_CODE
     , '****GRAND TOTAL****'
     , EPC_NORMAL_HOURS    
     , EPC_NH_PAY_AMT
     
     , EPC_LAST_NAME
     , EPC_PRN_CODE                
     , EPC_PROCESS_FLAG       
     , EPC_APRV_STATUS  
     , EPC_WORK_LOCATION
FROM DA1.EMPLOYEE_PAY_CADVW
WHERE EPC_ROW_ORDER <> 1

select * from DA1.EMPLOYEE_PAY_CADVW where trunc(epc_start_date) = to_date('11/10/2009', 'DD/MM/YYYY')

select to_number(1234.64, '9,999.9') from dual

select DECODE(:Pay Run Code, 'WEEK', TO_DATE(TRUNC(sysdate,'DAY')+1, 'YYYY-MM-DD'), TO_DATE(sysdate,'YYYY-MM-DD')) from dual

DECODE(:Pay Run Code, 'WEEK', TO_DATE(TRUNC(:Pay Period End,'DAY')+7, 'YYYY-MM-DD'), TO_DATE(:Pay Period End,'YYYY-MM-DD'))

select trunc(sysdate, 'DAY')+1 from dual

select DECODE(:Pay Run Code,'WEEK',TO_DATE(TRUNC(:Pay Period Start,'DAY')+1,'YYYY-MM-DD'),TO_DATE(:Pay Period Start,'YYYY-MM-DD'))