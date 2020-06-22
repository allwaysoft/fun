Set current schema = 'PSFNDV2' --DV2
Set current schema = 'PSFNTST'
Set current schema = 'PSFNDEV'



SELECT A.BUSINESS_UNIT, A.JOURNAL_ID, A.JOURNAL_DATE, A.UNPOST_SEQ, A.JOURNAL_LINE, A.JOURNAL_LINE_1, A.LEDGER, A.MONETARY_AMOUNT, A.MB_PR_AREA, A.MB_PR_HOURS, A.MB_PR_EMP_NAME, A.MB_PR_EMP_NUMBER, A.MB_PR_HOURS_DESCR, A.MB_ERNCD_DESCR, A.JOBCODE, A.DESCR, A.ACCOUNT, B.DESCR, A.FUND_CODE, A.DEPTID, A.DEPTID_DESCR, A.MB_ROLLUP_DEPTID, A.MB_DEPTID_DESCR, A.CHARTFIELD1, A.CHARTFIELD2, A.CHARTFIELD3, A.MB_CF3_DESCR,B.SETID,B.ACCOUNT,B.EFFDT
  FROM PS_MB_PYRLRPT_VW A, PS_GL_ACCOUNT_TBL B
  WHERE A.OPRID = 'MBTA1'
    AND ( A.LEDGER = 'ACTUALS'
     AND A.ACCOUNT IN ('5119000','5129000','5129950','5119950')
     AND A.FUND_CODE IN ('02','03','05')
     AND A.MB_ROLLUP_DEPTID = '230000'
     AND A.JOURNAL_DATE between {d'2011-03-05'} and {d'2011-03-11'}
     AND A.CHARTFIELD3 BETWEEN '001000' AND '099999'
     AND B.ACCOUNT = A.ACCOUNT
     AND B.EFFDT =
        (SELECT MAX(B_ED.EFFDT) FROM PS_GL_ACCOUNT_TBL B_ED
        WHERE B.SETID = B_ED.SETID
          AND B.ACCOUNT = B_ED.ACCOUNT
          AND B_ED.EFFDT <= CURRENT DATE) )

select * from PS_MB_PYRLRPT_VW a WHERE A.OPRID = 'KPABBA'

select oprid from PS_MB_PYRLRPT_VW group by oprid
          
select max(journal_date) from ps_mb_pyrlrpt_vw

select count(1) from PS_MB_PYRLRPT_SCTY B 

  select count(1) from PSOPRDEFN



select * from PS_MB_PYRLRPT_VW where oprid = 'KPABBA'

select * from PS_GL_ACCOUNT_TBL
------------------------------------------- SECURITY --------------------------------
select * from PSOPRDEFN where oprid = 'KPABBA'

select * from ps_mb_pyrlrpt_scty where oprid = 'KPABBA'       
----------------------------------- SECURITY -----------------------------------------

          
select * from 
ps_gl_account_tbl t1,
(select * from ps_gl_account_tbl) sub
where sub.account = t1.account

select JOURNAL_ID 
from PS_MB_PYRLRPT_VW a
where A.OPRID = 'KPABBA'          
    AND  A.LEDGER = 'ACTUALS'
     AND A.ACCOUNT IN ('5119000','5129000','5129950','5119950')
     AND A.FUND_CODE IN ('02','03','05')
     AND (A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%')      
     AND A.MB_ROLLUP_DEPTID = '220000'
     AND A.CHARTFIELD3 BETWEEN '001000' AND '099999'
     --AND A.JOURNAL_DATE between {d'2011-05-07'} and {d'201-05-13'}
group by JOURNAL_ID
               

bi,je should be in the year to date
and should not be in week bi and je

fund05
     
     
select distinct descr from PS_GL_ACCOUNT_TBL -- Function     

--BETWEEN :3 AND :4     
 
 FETCH FIRST 1 ROW ONLY;
 
where rownum <=100

     
select * from ps_in_pro_area_vw     
     
     select * from PS_INSTALLATION
     
     
     select LICENSE_CODE from PSOPTIONS
 
 
SELECT A.OPRID 
 , CASE A.FUND_CODE WHEN '05' THEN 'Operating' WHEN '02' THEN 'Capital' WHEN '03' THEN 'Reimbursable' END 
 , CASE WHEN SUM( A.MONETARY_AMOUNT) < 1000 THEN 'Other - OT numbers charged less than $1,000' ELSE A.MB_CF3_DESCR END 
 , A.MB_ROLLUP_DEPTID 
 , SUM(A.MONETARY_AMOUNT) 
 , A.JOURNAL_DATE 
 , CASE A.FUND_CODE WHEN '05' THEN 1 WHEN '02' THEN 2 WHEN '03' THEN 3 END 
  FROM PS_MB_PYRLRPT_VW a 
  , ( 
 SELECT MAX(effdt) mx_effdt 
 , SETID 
 , ACCOUNT 
  FROM PS_GL_ACCOUNT_TBL 
 WHERE effdt <= CURRENT DATE 
  GROUP BY setid, account ) b 
 WHERE A.LEDGER = 'ACTUALS' 
   AND A.ACCOUNT IN ('5119000','5129000','5129950','5119950') 
   AND A.FUND_CODE IN ('02','03','05') 
   AND A.CHARTFIELD3 BETWEEN '001000' AND '099999' 
   AND A.JOURNAL_ID NOT LIKE 'BI%' 
   AND mb_rollup_deptid IN ('220000', '230000') 
   AND a.account = b.account 
  GROUP BY CASE A.FUND_CODE WHEN '05' THEN 'Operating' WHEN '02' THEN 'Capital' WHEN '03' THEN 'Reimbursable' END, CASE A.FUND_CODE WHEN '05' THEN 1 WHEN '02' THEN 2 WHEN '03' THEN 3 END, A.MB_CF3_DESCR, A.MB_ROLLUP_DEPTID, A.JOURNAL_DATE


select * from ps_mb_bus_ot_vw where JOURNAL_DATE BETWEEN '2011-04-07' AND '2011-04-13'

select * from PS_MB_PYRLRPT_VW

select * from ps_dept_tbl where deptid like '22%'


select * from PS_MB_PYRLRPT_VW where 



select datepart(wk,'11/4/2007') from PS_MB_PYRLRPT_VW


SELECT STRIP(CHAR(YEAR(CURRENT DATE))) || SUBSTR(CHAR(DATE(((WEEK(CURRENT DATE)-1)* 7)+ 2)),5,6) FROM SYSIBM.SYSDUMMY1; 


Select current date , current date - (dayofweek(current date) + 1 ) days from sysibm.sysdummy1 

select substr('abc',1,2) from sysibm.sysdummy1 


select week(current date) from SYSIBM.SYSDUMMY1;

select * from ps_sf_prdn_area


Select Last_Day(current date) As EndOfMonth FROM SYSIBM.SYSDUMMY1;



select date('0001-01-01') + year(current date) years - 1 year from SYSIBM.SYSDUMMY1;

select days (current date - (dayofweek(current date) + 1) days) - days (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS- (DAY(CURRENT_DATE)-1) DAYS - 1 year + 6 month) from sysibm.sysdummy1

select days (current date - (dayofweek(current date) + 1) days) from sysibm.sysdummy1

select dayofweek(current date) from sysibm.sysdummy1

select ((CURRENT_DATE) - (MONTH(CURRENT_DATE)-1) MONTHS- (DAY(CURRENT_DATE)-1) DAYS - 1 year + 6 month)  from sysibm.sysdummy1

-----------------------------------------by class

select jobcode
     , descr
     , sum(case when A.JOURNAL_DATE between (current date - (dayofweek(current date) + 28) days) AND (current date - (dayofweek(current date) + 22) days) 
                                    AND A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%' then monetary_amount else 0 end)    --:p3,:p4 -- this for prev wk 
     , sum(case when A.JOURNAL_DATE between (current date - (dayofweek(current date) + 21) days) AND (current date - (dayofweek(current date) + 15) days) 
     								AND A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%' then monetary_amount else 0 end)    --:p5,:p6 -- this for curr wk
     , sum(monetary_amount)  -- this is for year to date
     , sum(case when A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%' then monetary_amount else 0 end)  -- this will help to get avg per week 
     , days (current date - (dayofweek(current date) + 1) days) - days (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS- (DAY(CURRENT_DATE)-1) DAYS - 1 year + 6 month)
       -- above function is to get the number of days till the report run date used to caliculate the average per week. We go by days but not by bweeks because of the          year start and year end weeks might be small and they should not be considerd as full week. get the days, divide by 7 to get weeks with the decimal.
from PS_MB_PYRLRPT_VW a
  WHERE A.OPRID = 'KPABBA'
     AND A.LEDGER = 'ACTUALS'
     AND A.ACCOUNT IN ('5119000','5129000','5129950','5119950')
     AND A.FUND_CODE IN ('05')--('02','03','05')
     --AND A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%'    
     AND A.MB_ROLLUP_DEPTID = '220000'
     AND A.JOURNAL_DATE BETWEEN (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS- (DAY(CURRENT_DATE)-1) DAYS - 1 year + 6 month) 
       --                     AND (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS - (DAY(CURRENT_DATE)-1) DAYS + 6 months - 1 day)  --:p1,:p2
     AND A.CHARTFIELD3 BETWEEN '001000' AND '099999'
group by jobcode
       , descr
       --, A.JOURNAL_DATE     
order by jobcode



select jobcode
     , descr
     , sum(case when A.JOURNAL_DATE between '2011-04-30' AND '2011-05-06'
                                    AND A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%' then monetary_amount else 0 end)    --:p3,:p4 -- this for prev wk 
     , sum(case when A.JOURNAL_DATE between '2011-05-07' AND '2011-05-13' 
     								AND A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%' then monetary_amount else 0 end)    --:p5,:p6 -- this for curr wk
     , sum(monetary_amount)  -- this is for year to date
     , sum(case when A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%' then monetary_amount else 0 end)  -- this will help to get avg per week 
from PS_MB_PYRLRPT_VW a
  WHERE A.OPRID = 'KPABBA'
     AND A.LEDGER = 'ACTUALS'
     AND A.ACCOUNT IN ('5119000','5129000','5129950','5119950')
     AND A.FUND_CODE IN ('05')--('02','03','05')
     --AND A.JOURNAL_ID NOT LIKE 'BI%' AND A.JOURNAL_ID NOT LIKE 'JE%'    
     AND A.MB_ROLLUP_DEPTID = '220000'
     AND A.JOURNAL_DATE BETWEEN '2011-04-30' and '2011-05-13' 
     AND A.CHARTFIELD3 BETWEEN '001000' AND '099999'
group by jobcode
       , descr
       --, A.JOURNAL_DATE     
order by jobcode

------------------------------------by class     

SELECT A.BUSINESS_UNIT 
 , A.TRANSACTION_GROUP 
 , A.ACCOUNTING_DT 
 , A.ACCTG_LINE_NO, A.ACCOUNT , A.DEPTID , A.FUND_CODE , A.PROJECT_ID , A.ADJUST_TYPE 
 , A.UNIT_OF_MEASURE , A.MONETARY_AMOUNT , A.ACCOUNTING_PERIOD , B.DT_TIMESTAMP 
 , B.SEQ_NBR , B.TRANSACTION_DATE , B.QTY , B.DISTRIB_TYPE 
 , B.INV_ITEM_ID 
 , C.DESCR 
 --, D.DESCR 
 , B.ORDER_NO 
  FROM PS_CM_ACCTG_LINE A 
  , PS_TRANSACTION_INV B 
  , PS_MASTER_ITEM_TBL C 
  , PS_GL_ACCOUNT_TBL D 
 WHERE A.ACCOUNT NOT IN ('1510000' , '1520000' , '1590495') 
   AND A.BUSINESS_UNIT = B.BUSINESS_UNIT 
   AND A.INV_ITEM_ID = B.INV_ITEM_ID 
   AND A.DT_TIMESTAMP = B.DT_TIMESTAMP 
   AND A.SEQ_NBR = B.SEQ_NBR 
   AND C.SETID = 'SHARE' 
   AND A.INV_ITEM_ID = C.INV_ITEM_ID 
   AND D.SETID = 'MBTA1' 
   AND A.ACCOUNT = D.ACCOUNT
   and A.ACCOUNTING_DT between {d'2011-04-02'} and {d'2011-04-08'}
     AND A.DEPTID = '233067' and b.inv_item_id = '00250132'


select * from PS_GL_ACCOUNT_TBL where account = '6122820' and SETID = 'MBTA1'
select * from PS_BUS_UNIT_TBL_FS where business_unit = 'CS001'

SELECT A.INV_ITEM_ID, A.DESCR, A.UNIT_OF_MEASURE, A.QTY, A.MONETARY_AMOUNT, A.ACCOUNT, A.TRANSACTION_GROUP, A.FUND_CODE, A.PROJECT_ID, A.ACCOUNT_DESCR, A.DEPTID, A.ACCOUNTING_DT, A.BUSINESS_UNIT, B.DESCR,B.BUSINESS_UNIT
  FROM PS_MB_IN_TRANS_DET A, PS_BUS_UNIT_TBL_FS B
  WHERE A.ACCOUNTING_DT = {d'2011-04-04'}
     AND A.DEPTID = '233067'
     AND A.inv_item_id = '00250132'
     AND B.BUSINESS_UNIT = A.BUSINESS_UNIT
  ORDER BY 8, 11, 6, 1, 12 DESC, 7


SELECT A.INV_ITEM_ID, A.DESCR, A.UNIT_OF_MEASURE, A.QTY, A.MONETARY_AMOUNT, A.ACCOUNT, A.TRANSACTION_GROUP, A.FUND_CODE, A.PROJECT_ID, A.ACCOUNT_DESCR, A.DEPTID, A.ACCOUNTING_DT, A.BUSINESS_UNIT, B.DESCR, C.JOURNAL_ID, CURRENT DATE,B.BUSINESS_UNIT
  FROM PS_MB_IN_TRANS_DET A, PS_BUS_UNIT_TBL_FS B, PS_CM_ACCTG_LINE C
  WHERE A.DEPTID BETWEEN :3 AND :4
     AND A.ACCOUNTING_DT BETWEEN :1 AND :2
     AND B.BUSINESS_UNIT = A.BUSINESS_UNIT
     AND A.FUND_CODE = '05'
     AND C.BUSINESS_UNIT = A.BUSINESS_UNIT
     AND C.TRANSACTION_GROUP = A.TRANSACTION_GROUP
     AND C.ACCOUNTING_DT = A.ACCOUNTING_DT
     AND C.ACCTG_LINE_NO = A.ACCTG_LINE_NO
  ORDER BY 8, 11, 6, 1, 12 DESC, 7



select count(1) from ps_gl_acct_cur_vw --1583
select count(1) from ps_dept_tbl_eff_vw --562
select count(1) from PS_GL_ACCOUNT_TBL  --2734
select count(1) from PS_CM_ACCTG_LINE --4472284     -- restrict by date
select count(1) from PS_TRANSACTION_INV --2179485    quantity
select count(1) from PS_MASTER_ITEM_TBL where setid = 'SHARE'--3021320  --3021312  -- use only category code = 00010
select count(1) from ps_gl_acct_cur_vw where SETID = 'MBTA1'--1590

select category_id, count(1) from  PS_MASTER_ITEM_TBL group by category_id
  
  SELECT C.INV_ITEM_ID, C.DESCR as ITEM_DESC
       --, D.DESCR
       , E.DEPTID, E.DESCR, E.DESCRSHORT
       --, A.DEPTID
       , sum(A.Monetary_amount), sum(B.QTY)
  FROM PS_CM_ACCTG_LINE A 
     , PS_TRANSACTION_INV B 
     , PS_MASTER_ITEM_TBL C 
--  , ps_gl_acct_cur_vw D  -- don't need this table
     , ps_dept_tbl_eff_vw E
--,     PS_BUS_UNIT_TBL_FS E
 WHERE A.ACCOUNT NOT IN ('1510000' , '1520000' , '1590495')
   AND A.BUSINESS_UNIT = B.BUSINESS_UNIT 
   AND A.INV_ITEM_ID = B.INV_ITEM_ID 
   AND A.DT_TIMESTAMP = B.DT_TIMESTAMP 
   AND A.SEQ_NBR = B.SEQ_NBR 
   AND C.SETID = 'SHARE'
   --AND C.CATEGORY_ID = '00010' 
   AND A.INV_ITEM_ID = C.INV_ITEM_ID 
   --AND D.SETID = 'MBTA1' 
   --AND A.ACCOUNT = D.ACCOUNT
   AND A.DEPTID = E.DEPTID
   --AND E.BUSINESS_UNIT = A.BUSINESS_UNIT
   AND A.FUND_CODE = '05'
   AND A.DEPTID BETWEEN '220000' AND '229999'
   AND A.ACCOUNTING_DT between {d'2011-04-02'} and {d'2011-04-08'}
group by  C.INV_ITEM_ID, C.DESCR, E.DEPTID, E.DESCR, E.DESCRSHORT


select * from PS_MASTER_ITEM_TBL
   
   select count(1) from PS_GL_ACCOUNT_TBL
   
   
   select deptid from PS_CM_ACCTG_LINE group by deptid
   
   select * from PS_CM_ACCTG_LINE WHERE ACCOUNT NOT IN ('1510000' , '1520000' , '1590495') 
   
select (current date - (dayofweek(current date) + 7) days), (current date - (dayofweek(current date) + 1) days) from sysibm.sysdummy1
select max(A.JOURNAL_DATE) from PS_MB_PYRLRPT_VW a
select (current date - (dayofweek(current date) + 15) days) from sysibm.sysdummy1
select (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS- (DAY(CURRENT_DATE)-1) DAYS - 1 year + 6 month) from sysibm.sysdummy1
select days (current date - (dayofweek(current date) + 1) days) - days (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS- (DAY(CURRENT_DATE)-1) DAYS - 1 year + 6 month) from sysibm.sysdummy1
select CURRENT_DATE - (DAY(CURRENT_DATE)-1) DAYS from SYSIBM.SYSDUMMY1;

select (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS- (DAY(CURRENT_DATE)-1) DAYS - 1 year + 6 month)  from SYSIBM.SYSDUMMY1;

select (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS - (DAY(CURRENT_DATE)-1) DAYS + 6 months - 1 day) from SYSIBM.SYSDUMMY1;

select ((CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS - (DAY(CURRENT_DATE)-1) DAYS) + 1 year) + 6 month - 1 day  from SYSIBM.SYSDUMMY1;


select (CURRENT DATE - (DAYOFWEEK(CURRENT DATE)) days - 7 day),  (CURRENT DATE - (DAYOFWEEK(CURRENT DATE)) days - 1 day) from SYSIBM.SYSDUMMY1;


select year(current_date)+1 from SYSIBM.SYSDUMMY1;

select current_date + 1 year from SYSIBM.SYSDUMMY1;

select CURRENT_DATE - (weeks(CURRENT_DATE)-1)weeks from SYSIBM.SYSDUMMY1;

SELECT   current date,
         current date - (dayofweek(current date) + 14) days,
         current date - (dayofweek(current date) + 8) days,
         current date - (dayofweek(current date) + 7) days,
         current date - (dayofweek(current date) + 1) days
FROM     sysibm.sysdummy1 

select CURRENT DATE - (DAYOFWEEK(CURRENT DATE)) days - 7 day from sysibm.sysdummy1
select CURRENT DATE - (DAYOFWEEK(CURRENT DATE)) days - 1 day from sysibm.sysdummy1

select current_date - dayofweek(current date) from sysibm.sysdummy1

select month(current_date) from sysibm.sysdummy1

select current_date - 1 WEEKS from sysibm.sysdummy1


select (current date - (dayofweek(current date) + 14) days) from sysibm.sysdummy1

select (current date - (dayofweek(current date) + 1) days)   from sysibm.sysdummy1

select %currentdatein from sysibm.sysdummy1

select deptid, count(1) from ps_dept_tbl_eff_vw group by deptid order by count(1) desc
select account, count(1) from ps_gl_acct_cur_vw group by account order by count(1) desc


select * from ps_mb_inventory_vw where 

select 'B' from sysibm.sysdummy1 group by 'B'

select * from ps_mb_runctl_in where oprid = 'KPABBA' and run_cntl_id = 'ADHOC'
   
   
   
   select * from PS_MB_TREENODE_SVW
   
select * from psfndev.PS_MB_RUNCTL_IN02 where oprid = 'MBBATCH'

select * from PS_MB_RUNCTL_IN where oprid = 'MBBATCH'

select * from PS_MB_RUNCTL_IN02 where oprid = 'MBBATCH' 

and run_cntl_id = 'MBINOP01_FP'

inser

select * from PS_MB_RUNCTL_IN02 where oprid = 'MBBATCH'

select run_cntl_id, count(1) from PS_MB_RUNCTL_IN02 where oprid = 'MBBATCH' group by run_cntl_id


insert into PS_MB_RUNCTL_IN02 
select oprid, 'MBINOP02_'||DEPTID, DEPTID from PS_MB_RUNCTL_IN02 where oprid = 'MBBATCH' and run_cntl_id = 'MBINOP01_FP'


insert into PS_MB_RUNCTL_IN 
select OPRID,'MBINOP03_RPT',FROM_DATE,THRU_DATE,DEPTID_FROM,DEPTID_TO,MB_LOCATION_FROM,MB_LOCATION_TO,TREE_EFFDT,TREE_LEVEL_NUM,PARENT_NODE_NAME,SETID,TREE_NAME from ps_mb_runctl_in where run_cntl_id= 'MBINOP02_225241'


insert into PS_MB_RUNCTL_IN
select b.OPRID,'MBINOP02_'||b.deptid,a.FROM_DATE,a.THRU_DATE,DEPTID_FROM,DEPTID_TO,MB_LOCATION_FROM,MB_LOCATION_TO,TREE_EFFDT,TREE_LEVEL_NUM,PARENT_NODE_NAME,SETID,TREE_NAME 
from PS_MB_RUNCTL_IN02 b, PS_MB_RUNCTL_IN a
where b.oprid = a.oprid
and b.oprid = 'MBBATCH' 
and b.run_cntl_id = 'MBINOP02_FP'
and a.run_cntl_id = 'MBINOP01_EX'



--delete from PSFNDEV.PS_PRCSRUNCNTL where OPRID = 'MBBATCH' and run_cntl_id like 'MBINOP02_22%'

select * from PSFNDEV.PS_PRCSRUNCNTL where OPRID = 'MBBATCH' and run_cntl_id like 'MBINOP0%'


insert into PS_PRCSRUNCNTL
select b.OPRID,'MBINOP02_'||b.deptid,a.language_cd, a.language_option
from PS_MB_RUNCTL_IN02 b, PS_PRCSRUNCNTL a
where b.oprid = a.oprid
and b.oprid = 'MBBATCH' 
and b.run_cntl_id = 'MBINOP02_FP'
and a.run_cntl_id = 'MBINOP01_EX'

select * from PS_PRCSRUNCNTL where 

OPRID,RUN_CNTL_ID,FROM_DATE,THRU_DATE,DEPTID_FROM,DEPTID_TO,MB_LOCATION_FROM,MB_LOCATION_TO,TREE_EFFDT,TREE_LEVEL_NUM,PARENT_NODE_NAME,SETID,TREE_NAME
MBBATCH,MBINOP02_225241,2011-07-02,2011-07-08,,,,,2010-07-01,4,220000,MBTA1,CC_DEPARTMENT

select * from PS_PRCSRUNCNTL where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP%'

select * from PS_PRCSRUNCNTL where oprid = 'MBBATCH' and run_cntl_id like 'DUMMY%'

insert into PS_PRCSRUNCNTL select OPRID,'MBINOP03_RPT',LANGUAGE_CD,LANGUAGE_OPTION from PS_PRCSRUNCNTL where RUN_CNTL_ID = 'MBINOP02_225339'


OPRID,RUN_CNTL_ID,LANGUAGE_CD,LANGUAGE_OPTION
MBBATCH,MBINOP02_225339,ENG,O

select * from PS_MB_PYRLRPT_MSTR

select * from PS_MB_RUNCTL_IN03

select * from PS_SCHDLDEFN where SCHEDULENAME like '%MBINOP%'

select * from PS_PRCSJOBDEFN where PRCSJOBNAME like '%MBINOP%'

in ('MB_IN_RC_UPDATE ');


  
  
  
SELECT A.DESCR, A.DESCR100, A.MB_ROLLUP_DEPTID, SUM( A.MONETARY_AMOUNT), A.SORT_SOURCE_CODE, A.SORT_CATEGORY, A.FROM_DATE, A.TO_DATE
  FROM PS_MB_OT_FUNC_VW A
  WHERE A.OPRID = 'KPABBA'
    --AND ( A.OPRID = :4
     --AND A.RUN_CNTL_ID = :5 )
  GROUP BY  A.DESCR,  A.DESCR100,  A.MB_ROLLUP_DEPTID,  A.SORT_SOURCE_CODE,  A.SORT_CATEGORY,  A.FROM_DATE,  A.TO_DATE  
  
  
  
  
  select * from PS_MB_OT_FUNC_VW
  
  
  
  SELECT A.DESCR, A.DESCR100, A.MB_ROLLUP_DEPTID, SUM( A.MONETARY_AMOUNT), A.SORT_SOURCE_CODE, A.SORT_CATEGORY, A.FROM_DATE, A.TO_DATE
  FROM PS_MB_OT_FUNC_VW A
  WHERE A.OPRID = 'MBBATCH'
     AND A.RUN_CNTL_ID = 'MBINOP03_RPT'
  GROUP BY  A.DESCR,  A.DESCR100,  A.MB_ROLLUP_DEPTID,  A.SORT_SOURCE_CODE,  A.SORT_CATEGORY,  A.FROM_DATE,  A.TO_DATE
  
  
    SELECT A.DESCR, A.DESCR100, A.MB_ROLLUP_DEPTID, SUM( A.MONETARY_AMOUNT), A.SORT_SOURCE_CODE, A.SORT_CATEGORY, A.FROM_DATE, A.TO_DATE
  FROM PS_MB_OT_FUNC_VW A
  WHERE A.OPRID = 'KPABBA'
     AND A.RUN_CNTL_ID = 'mb_kr_cr_rcid' 
  GROUP BY  A.DESCR,  A.DESCR100,  A.MB_ROLLUP_DEPTID,  A.SORT_SOURCE_CODE,  A.SORT_CATEGORY,  A.FROM_DATE,  A.TO_DATE





  
  select * from PS_MB_PYRLRPT_SCTY where oprid = 'MBBATCH'
  select * from PS_MB_PYRLRPT_SCTY where oprid = 'KPABBA'
  select * from PSOPRDEFN where oprid = 'MBBATCH'
  select * from PS_MB_PYRLRPT_MSTR
  
  insert into psfntst.PS_MB_PYRLRPT_SCTY
  select * from psfndev.PS_MB_PYRLRPT_SCTY where oprid = 'MBBATCH'
  
  select * from psfntst.PS_MB_PYRLRPT_SCTY where oprid = 'MBBATCH'
  
  select * from PSFNDEV.PS_PRCSRUNCNTL where oprid = 'MBBATCH'
  
  select * from ps_mb_runctl_in where oprid = 'MBBATCH' and run_cntl_id = 'MBINOP03_RPT'
  


select * from PS_MB_RUNCTL_IN where oprid = 'MBBATCH' 

update PS_MB_RUNCTL_IN 
set from_date = '2011-04-02', thru_Date= '2011-04-08' 
where oprid = 'MBBATCH' and from_date = '2011-05-21' and thru_date = '2011-05-27'

select * from PS_MB_RUNCTL_IN02 where oprid = 'MBBATCH' 

  
  
  select * from 

update ps_SCHDLITEM set run_cntl_id = 'MBINOP02_'||run_cntl_id--'MBINOP02_'||run_cntl_id--substr(ltrim(rtrim(run_cntl_id)),8,length(ltrim(rtrim(run_cntl_id))))--'MBINOP02'||run_cntl_id--substr(ltrim(rtrim(run_cntl_id)),8,length(ltrim(rtrim(run_cntl_id)))) 
where upper(run_cntl_id) = lower(run_cntl_id) 
and run_cntl_id <> 'DUMMY' 
and schedulename = 'MBINOP2'
and run_cntl_id not like '%SUB%'
--substr(ltrim(rtrim(run_cntl_id)),7,length(ltrim(rtrim(run_cntl_id))))
--where upper(run_cntl_id) <> lower(run_cntl_id) and run_cntl_id <> 'DUMMY' and schedulename = 'MBINOP2'

select --run_cntl_id--
substr(ltrim(rtrim(run_cntl_id)),10,length(ltrim(rtrim(run_cntl_id)))) 
from ps_SCHDLITEM
where upper(run_cntl_id) <> lower(run_cntl_id) 
and run_cntl_id <> 'DUMMY' 
and schedulename = 'MBINOP2'
--and run_cntl_id not like '%SUB%'  
  

update ps_SCHDLNODEPARM set parmvalue = 'MBINOP02_'||parmvalue   
where SCHEDULENAME in ('MBINOP2')
and PARMKEY = 'PRCSRUNCNTL.RUN_CNTL_ID'


select * from ps_SCHDLNODEPARM
where SCHEDULENAME in ('MBINOP2')
and PARMKEY = 'PRCSRUNCNTL.RUN_CNTL_ID'

select substr(ltrim(rtrim(parmvalue)),14,length(ltrim(rtrim(parmvalue))))  
from ps_SCHDLNODEPARM, ps_schdlitem b
where b.SCHEDULENAME in ('MBINOP2')
and substr(ltrim(rtrim(parmvalue)),14,length(ltrim(rtrim(parmvalue)))) =  substr(ltrim(rtrim(run_cntl_id)),10,length(ltrim(rtrim(run_cntl_id)))) 
and PARMKEY = 'PRCSRUNCNTL.RUN_CNTL_ID'
and upper(run_cntl_id) <> lower(run_cntl_id) 
and run_cntl_id <> 'DUMMY' 
and b.schedulename = 'MBINOP2'

  
select * from psfndev.ps_SCHDLDEFN where SCHEDULENAME in ('MBINOP2');
select * from psfndev.ps_SCHDLDEFNLANG where SCHEDULENAME in ('MBINOP2');
select * from psfndev.ps_SCHDLITEM where SCHEDULENAME in ('MBINOP2');
select * from psfndev.ps_SCHDLMESSAGE where SCHEDULENAME in ('MBINOP2');
select * from psfndev.ps_SCHDLNODEPARM where SCHEDULENAME in ('MBINOP2');
select * from psfndev.ps_SCHDLNOTIFY where SCHEDULENAME in ('MBINOP2');
select * from psfndev.ps_SCHDLRPTDIST where SCHEDULENAME in ('MBINOP2');
select * from psfndev.ps_SCHDLTEXT where SCHEDULENAME in ('MBINOP2');

select * from psfntst.ps_SCHDLDEFN where SCHEDULENAME in ('MBINOP2');
select * from psfntst.ps_SCHDLDEFNLANG where SCHEDULENAME in ('MBINOP2');
select * from psfntst.ps_SCHDLITEM where SCHEDULENAME in ('MBINOP2');
select * from psfntst.ps_SCHDLMESSAGE where SCHEDULENAME in ('MBINOP2');
select * from psfntst.ps_SCHDLNODEPARM where SCHEDULENAME in ('MBINOP2');
select * from psfntst.ps_SCHDLNOTIFY where SCHEDULENAME in ('MBINOP2');
select * from psfntst.ps_SCHDLRPTDIST where SCHEDULENAME in ('MBINOP2');
select * from psfntst.ps_SCHDLTEXT where SCHEDULENAME in ('MBINOP2');



select * from psfndev.PS_PRCSJOBDEFN where PRCSJOBNAME in ('MBINOP2');
select * from psfndev.PS_PRCSJOBDEFNLANG where PRCSJOBNAME in ('MBINOP2');
select * from psfndev.PS_PRCSJOBGRP where PRCSJOBNAME in ('MBINOP2');
select * from psfndev.PS_PRCSJOBITEM where PRCSJOBNAME in ('MBINOP2');
select * from psfndev.PS_PRCSJOBPNL where PRCSJOBNAME in ('MBINOP1');
select * from psfndev.PS_PRCSJOBNOTIFY where PRCSJOBNAME in ('MBINOP1');
select * from psfndev.PS_PRCSJOBCNTDIST where PRCSJOBNAME in ('MBINOP1');
select * from psfndev.PS_PRCSJOBMESSAGE where PRCSJOBNAME in ('MBINOP1');  
  
select * from psfntst.PS_PRCSJOBDEFN where PRCSJOBNAME in ('MBINOP2');
select * from psfntst.PS_PRCSJOBDEFNLANG where PRCSJOBNAME in ('MBINOP2');
select * from psfntst.PS_PRCSJOBGRP where PRCSJOBNAME in ('MBINOP2');
select * from psfntst.PS_PRCSJOBITEM where PRCSJOBNAME in ('MBINOP2');
select * from psfntst.PS_PRCSJOBPNL where PRCSJOBNAME in ('MBINOP1');
select * from psfntst.PS_PRCSJOBNOTIFY where PRCSJOBNAME in ('MBINOP1');
select * from psfntst.PS_PRCSJOBCNTDIST where PRCSJOBNAME in ('MBINOP1');
select * from psfntst.PS_PRCSJOBMESSAGE where PRCSJOBNAME in ('MBINOP1');  


  
  
select * from ps_mb_runctl_in a, ps_mb_runctl_in02 b
where a.oprid = 'MBBATCH' and a.run_cntl_id = 'MBINOP02_231008' 
and a.run_cntl_id = b.run_cntl_id


update ps_mb_runctl_in02 a set a.run_cntl_id = 'MBINOP03_RPT_SUB'
where  a.oprid = 'MBBATCH' and a.run_cntl_id = 'MBINOP03_SUB_RPT'  



select * from ps_mb_runctl_in02 where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP03%' --MBINOP03_RPT_SUB

update ps_mb_runctl_in set run_cntl_id = replace(run_cntl_id,'_SUB_', '_') where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP02%' and run_cntl_id not in('MBINOP02_SUB_FP')

update ps_mb_runctl_in02 set run_cntl_id = replace(run_cntl_id,'_SUB_', '_') where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP02%' and run_cntl_id not in('MBINOP02_SUB_FP')

select run_cntl_id, replace(run_cntl_id,'_SUB_', '_') from ps_mb_runctl_in where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP02%' and run_cntl_id not in('MBINOP02_SUB_FP')

select run_cntl_id, replace(run_cntl_id,'_SUB_', '_') from ps_mb_runctl_in02 where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP02%' and run_cntl_id not in('MBINOP02_SUB_FP')


update PS_MB_RUNCTL_IN set from_date = '2011-04-02', thru_Date= '2011-04-08' where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP0%'

select * from PS_MB_RUNCTL_IN02 where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP0%' 



   
select * from ps_mb_runctl_in where oprid = 'MBBATCH'


insert into ps_mb_runctl_in
 SELECT
   'MBBATCH' 
 , 'MBINOP03_SUB_RPT'
 , '2011-08-20', '2011-08-26','','' ,'' ,'' , '2011-07-01'
 , 4, '230000', 'MBTA1', 'CC_DEPARTMENT'
from sysibm.sysdummy1    


MBINOP02_BUS_FP
MBINOP01_BUS_EX
MBINOP03_BUS_RPT



   
OPRID	RUN_CNTL_ID	FROM_DATE	THRU_DATE	DEPTID_FROM	DEPTID_TO	MB_LOCATION_FROM	MB_LOCATION_TO	TREE_EFFDT	TREE_LEVEL_NUM	PARENT_NODE_NAME	SETID	TREE_NAME
MBBATCH	MBINOP02_224000	2011-08-20	2011-08-26					2011-07-01	5	224000	MBTA1	CC_DEPARTMENT   



select distinct psfndev.rolename from PSDISTROLE_VW where rolename like 'MB_IN_RPT_OP%'

select * from psfndev.PSROLEDEFN where rolename like 'MB_IN_RPT_OP%'

select * from psfndev.ps_SCHDLTEXT where SCHEDULENAME in ('MBINOP2');
select * from psfntst.ps_SCHDLTEXT where SCHEDULENAME in ('MBINOP2');



select * from psfndev.psrolemember where rolename like 'MB_IN_RPT_OP%'

select * from psfndev.psroleuser where rolename like 'MB_IN_RPT_OP%'



select * from psfntst.ps_mb_runctl_in where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP0%' 

select * from psfndev.ps_mb_runctl_in where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP0%'

select * from psfntst.PS_MB_RUNCTL_IN02 where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP0%' 




select * from PS_MB_RUNCTL_IN A 
where oprid = 'MBBATCH' and run_cntl_id like 'MBINOP02%' 
and not exists (Select 'X' from PS_PRCSRUNCNTL b where A.OPRID = B.OPRID and A.RUN_CNTL_ID = B.RUN_CNTL_ID)

or

update (select A.OPRID, A.RUN_CNTL_ID as rc1, B.RUN_CNTL_ID as rc2 
from PS_MB_RUNCTL_IN A LEFT OUTER JOIN PS_PRCSRUNCNTL b on A.OPRID = B.OPRID and A.RUN_CNTL_ID = B.RUN_CNTL_ID
where A.oprid = 'MBBATCH' 
and A.run_cntl_id like 'MBINOP0%' and b.run_cntl_id is null)
set rc2 = rc1


insert into PS_PRCSRUNCNTL
select A.OPRID, A.RUN_CNTL_ID,'ENG', '0' from PS_MB_RUNCTL_IN A LEFT OUTER JOIN PS_PRCSRUNCNTL b on A.OPRID = B.OPRID and A.RUN_CNTL_ID = B.RUN_CNTL_ID
where A.oprid = 'MBBATCH' 
and A.run_cntl_id like 'MBINOP0%' and b.run_cntl_id is null


update ps_prcsruncntl a set a.run_cntl_id = (select run_cntl_id from ps_mb_runctl_in b where A.OPRID = B.OPRID and b.oprid = 'MBBATCH' and b.run_cntl_id like 'MBINOP0%' and a.run_cntl_id is null)

where a.run_cntl_id is null
 
select * from  ps_prcsruncntl a 
where A.oprid = 'MBBATCH' 
and A.run_cntl_id like 'MBINOP0%' 
and a.run_cntl_id is null


select * from PS_PRCSRUNCNTL  where A.oprid = 'MBBATCH' and A.run_cntl_id like 'MBINOP0%' 