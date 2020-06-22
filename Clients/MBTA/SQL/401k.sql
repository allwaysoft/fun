
set echo off
set feedback off
set verify off
set linesize 10000
set pages 0 emb on newp none
set underline off
set termout on
set heading off
set recsep off
set trimspool on

accept Company_code prompt 'Enter Company Code:'
accept Prn_code prompt 'Enter Pay Run Code:'
accept Pay_Year prompt 'Enter Pay Year in YYYY format:'
accept Pay_period prompt 'Enter Pay Period:'

With Temp_Select as
(
select 1 as Col_Id, 'AAA' as Col_Id1, 'SSN           PARTICIPANT NAME              401K      MATCH     PROFIT              BIRTH     HIRE      ENTRY     TERM      ADDRESS                                                     CITY                ST   ZIP CODE' Col_Data
from dual 
UNION 
SELECT 2 as Col_Id,
        EMP_LAST_NAME Col_Id1,
        RPAD(EMP_SIN_NO, 14)
     || RPAD(EMP_LAST_NAME || ', ' || EMP_FIRST_NAME || ' ' || EMP_MIDDLE_NAME, 30) 
     || LPAD(LTRIM(REPLACE(TO_CHAR(SUM(PHY_PAY_AMOUNT)*-1, '9999999999.00'), '.','')), 10)  
     || LPAD(' ', 30)
     || RPAD(TO_CHAR(EMP_DATE_OF_BIRTH, 'MM-DD-YYYY'), 10) 
     || LPAD(' ', 30)
     || RPAD(UPPER(EMP_ADDRESS1), 60)  
     || RPAD(UPPER(EMP_ADDRESS3), 20)  
     || RPAD(UPPER(EMP_STATE_CODE), 5) 
     || SUBSTR(EMP_ZIP_CODE, 1, 5)        Col_Data
FROM PYEMPLOYEE
   , PYEMPPAYHIST
WHERE EMP_NO = PHY_EMP_NO
--AND PHY_EMP_NO = '01015'
AND PHY_TRAN_TYPE = 'DE'
AND PHY_TRAN_CODE IN ('401C', '401K')
AND PHY_COMP_CODE = '&Company_code'
AND PHY_PRN_CODE = '&Prn_code'
AND PHY_PPR_YEAR = '&Pay_Year'
AND PHY_PPR_PERIOD = '&Pay_period'
GROUP BY RPAD(EMP_SIN_NO, 14), EMP_LAST_NAME
       , RPAD(EMP_LAST_NAME || ', ' || EMP_FIRST_NAME || ' ' || EMP_MIDDLE_NAME, 30)
       , LPAD('', 30)
       , RPAD(TO_CHAR(EMP_DATE_OF_BIRTH, 'MM-DD-YYYY'), 10)
       , RPAD(UPPER(EMP_ADDRESS1), 60)
       , RPAD(UPPER(EMP_ADDRESS3), 20)
       , RPAD(UPPER(EMP_STATE_CODE), 5)
       , SUBSTR(EMP_ZIP_CODE, 1, 5)
--ORDER BY RPAD(EMP_LAST_NAME || ', ' || EMP_FIRST_NAME || ' ' || EMP_MIDDLE_NAME, 30)
)
Select Temp_Select.Col_Data
from temp_Select
Order By Temp_Select.Col_id, Temp_Select.Col_id1 ; 


spool \\Fileserver1\Operations\kranthiPabba\MISC\SQL\401k.txt
/

spool off