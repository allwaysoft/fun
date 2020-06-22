select
       CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Lost Time' 
              ElSE 'Open Lost Time'
         END
            ELSE 
              CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Medical Only' 
                ElSE 'Open Medical Only'
              END              
       END 
       --|| ' ' || convert(varchar(10), COUNT(DISTINCT(G.MB_CLM_NBR))) 
       || ' Claims'  "Claim Type"
     , G.MB_COVRG_CODE  
     , SUM(ISNULL(G.MB_RESERVE_AMT,0)) + SUM(ISNULL(G.MB_WRK_PAY_REFUND,0)) - SUM(ISNULL(G.MB_WRK_PAY_TOT_AMT,0)) "O/S Reserve" 
     , SUM(ISNULL(G.MB_WRK_PAY_TOT_AMT),0) Paid
     , SUM(ISNULL(G.MB_WRK_PAY_RECOVER),0) Recovery
FROM
(---------------3
select D.MB_CLM_NBR MB_CLM_NBR
     --, F.MB_PROCESS_ID  
     --, D.MB_COVERAGE_ID
     , D.MB_COVRG_CODE MB_COVRG_CODE
     , CASE WHEN D.MB_WRK_CASE_STATUS = 'C' THEN 'C' ELSE 'XXX' END MB_WRK_CASE_STATUS
     , CASE WHEN D.MB_NCCI_INJ_CD='5' THEN '5' ELSE 'XX' END MB_NCCI_INJ_CD      
     , max(D.MB_RESERVE_AMT) MB_RESERVE_AMT
     --, max(D.MB_CLM_PAID_AMT) MB_CLM_PAID_AMT
     , sum(F.MB_WRK_PAY_RECOVER) MB_WRK_PAY_RECOVER
     , sum(F.MB_WRK_PAY_REFUND)  MB_WRK_PAY_REFUND       
     , sum(F.MB_WRK_PAY_TOT_AMT) MB_WRK_PAY_TOT_AMT
--     , sum(max(D.MB_RESERVE_AMT)) + sum(F.MB_WRK_PAY_REFUND) - sum(F.MB_WRK_PAY_TOT_AMT) "O/S Reserve"
--     , sum(F.MB_WRK_PAY_TOT_AMT) Paid
from
( ------------------2
select D.MB_CLM_NBR MB_CLM_NBR
     , 
     D.MB_COVERAGE_ID MB_COVERAGE_ID
     , D.MB_COVRG_CODE MB_COVRG_CODE
     , D.MB_PROCESS_ID MB_PROCESS_ID      
     , sum(E.MB_RESERVE_AMT) MB_RESERVE_AMT
     --, sum(E.MB_CLM_PAID_AMT) MB_CLM_PAID_AMT
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
from       
(------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
FROM PS_MB_CLM_PER_TBL A
  WHERE A.EMPLID = 'DUMMY'
  AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --AND A.MB_NCCI_INJ_CD <> ''
) A --------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_CLM_NBR  = A.MB_CLM_NBR
  AND D.MB_PROCESS_ID = E.MB_PROCESS_ID
  AND D.MB_COVERAGE_ID = E.MB_COVERAGE_ID
  AND D.MB_CLM_NBR = E.MB_CLM_NBR
group by D.MB_CLM_NBR
       , 
       D.MB_COVERAGE_ID
       , D.MB_COVRG_CODE
       , D.MB_PROCESS_ID
       , A.MB_WRK_CASE_STATUS
       , A.MB_NCCI_INJ_CD            
) D -------------------2 end
left outer join PS_MB_WRK_PAY_TBL F
--where 
   on D.MB_CLM_NBR = F.MB_CLM_NBR
  AND D.MB_PROCESS_ID = F.MB_PROCESS_ID
  AND D.MB_COVERAGE_ID = F.MB_COVERAGE_ID
  AND D.MB_COVRG_CODE = F.MB_COVRG_CODE
--WHERE D.MB_COVRG_CODE = 'INDEMN'
group by D.MB_CLM_NBR 
       --, F.MB_PROCESS_ID  
      -- , D.MB_COVERAGE_ID
       , D.MB_COVRG_CODE
     , CASE WHEN D.MB_WRK_CASE_STATUS = 'C' THEN 'C' ELSE 'XXX' END 
     , CASE WHEN D.MB_NCCI_INJ_CD='5' THEN '5' ELSE 'XX' END
--order by 2,4,1 
) G   --------------3 end      
GROUP BY MB_WRK_CASE_STATUS, MB_NCCI_INJ_CD, MB_COVRG_CODE