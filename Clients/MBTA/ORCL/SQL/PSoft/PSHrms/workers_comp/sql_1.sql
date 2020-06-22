select HH.rowid
     , HH.rowid2
     , year(HH.fy_year)
     , HH.claim_type
     , HH.coverage_type
     , HH.os_reserves
     , HH.paid
from
(        -------------------4
select 1 rowid
     , CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 10
              ElSE 1
         END
            ELSE 
              CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 30
                ElSE 20
              END              
       END rowid2 
     , CASE WHEN month(G.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)))
       END  fy_year
     , CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Lost Time' 
              ElSE 'Open Lost Time'
         END 
            ELSE 
              CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Medical Only' 
                ElSE 'Open Medical Only'
              END              
       END 
       --|| ' ' || convert(varchar(10), COUNT(DISTINCT(G.MB_CLM_NBR))) 
       || ' Claims'  claim_type
     , CASE WHEN G.MB_COVRG_CODE = 'EXPENS' THEN 'Expense'
            WHEN G.MB_COVRG_CODE = 'INDEMN' THEN 'Indemnity'
            WHEN G.MB_COVRG_CODE = 'LEGAL'  THEN 'Legal'
            WHEN G.MB_COVRG_CODE = 'MEDICA' THEN 'Medical'
            WHEN G.MB_COVRG_CODE = 'OTHER' THEN 'Other'
       END  coverage_type            
     , ISNULL(SUM(G.MB_RESERVE_AMT), 0) + ISNULL(SUM(G.MB_WRK_PAY_REFUND), 0) - ISNULL(SUM(G.MB_WRK_PAY_TOT_AMT), 0) os_reserves
     , ISNULL(SUM(G.MB_WRK_PAY_TOT_AMT), 0) paid
    -- , ISNULL(SUM(G.MB_WRK_PAY_RECOVER), 0) Recovery
FROM
(                                   -----------------3
select 1,
       D.MB_CLM_NBR MB_CLM_NBR
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
     , D.MB_OCC_DT MB_OCC_DT
--     , sum(max(D.MB_RESERVE_AMT)) + sum(F.MB_WRK_PAY_REFUND) - sum(F.MB_WRK_PAY_TOT_AMT) "O/S Reserve"
--     , sum(F.MB_WRK_PAY_TOT_AMT) Paid
from
(                                   ------------------2
select D.MB_CLM_NBR MB_CLM_NBR
     , D.MB_COVERAGE_ID MB_COVERAGE_ID
     , D.MB_COVRG_CODE MB_COVRG_CODE
     , D.MB_PROCESS_ID MB_PROCESS_ID      
     , sum(E.MB_RESERVE_AMT) MB_RESERVE_AMT
     --, sum(E.MB_CLM_PAID_AMT) MB_CLM_PAID_AMT
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT
from       
(                                   ------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT
FROM PS_MB_CLM_PER_TBL A, PS_MB_JOB_VW B 
  WHERE B.EMPLID = A.EMPLID
     AND B.EMPL_RCD = A.EMPL_RCD
     AND B.EFFDT =
        (SELECT MAX(B_ED.EFFDT) FROM PS_MB_JOB_VW B_ED
        WHERE B.EMPLID = B_ED.EMPLID
          AND B.EMPL_RCD = B_ED.EMPL_RCD
          AND B_ED.EFFDT <= SUBSTRING(CONVERT(CHAR,GETDATE(),102), 1, 10))
    AND B.EFFSEQ =
        (SELECT MAX(B_ES.EFFSEQ) FROM PS_MB_JOB_VW B_ES
        WHERE B.EMPLID = B_ES.EMPLID
          AND B.EMPL_RCD = B_ES.EMPL_RCD
          AND B.EFFDT = B_ES.EFFDT)
    AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --And A.MB_CLM_NBR = '900114954'
  --And A.EMPLID = 'C03760'
--AND A.MB_WRK_CASE_STATUS <> 'C'
--AND A.MB_NCCI_INJ_CD <> '5'  
AND A.MB_NCCI_INJ_CD <> ''
) A                                 ------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_COVRG_CODE IN ('EXPENS','INDEMN','LEGAL','MEDICA','OTHER')
  AND D.MB_CLM_NBR  = A.MB_CLM_NBR
  AND D.MB_PROCESS_ID = E.MB_PROCESS_ID
  AND D.MB_COVERAGE_ID = E.MB_COVERAGE_ID
  AND D.MB_CLM_NBR = E.MB_CLM_NBR
group by D.MB_CLM_NBR
       , D.MB_COVERAGE_ID
       , D.MB_COVRG_CODE
       , D.MB_PROCESS_ID
       , A.MB_WRK_CASE_STATUS
       , A.MB_NCCI_INJ_CD            
       , A.MB_OCC_DT
) D                                -------------------2 end
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
       , D.MB_OCC_DT
--order by 2,4,1



UNION ALL


------------------------------------------------------------------------------------
--- BELOW FOR DUMMIES
------------------------------------------------------------------------------------
select 1,
       D.MB_CLM_NBR MB_CLM_NBR
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
     , D.MB_OCC_DT MB_OCC_DT
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
     , A.MB_OCC_DT MB_OCC_DT
from       
(------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT 
FROM PS_MB_CLM_PER_TBL A
  WHERE A.EMPLID = 'DUMMY'
  AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --AND A.MB_NCCI_INJ_CD <> ''
) A --------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_COVRG_CODE IN ('EXPENS','INDEMN','LEGAL','MEDICA','OTHER')
  AND D.MB_CLM_NBR  = A.MB_CLM_NBR
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
       , A.MB_OCC_DT                     
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
       , D.MB_OCC_DT     
--order by 2,4,1 
------------------------------------------------------------------------------------
--END DUMMIES
------------------------------------------------------------------------------------
 
) G                                ------------------3 end      
GROUP BY MB_WRK_CASE_STATUS
       , MB_NCCI_INJ_CD
       , MB_COVRG_CODE
       , CASE WHEN month(G.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)))
         END




--2222222222222222222222222222222222222222222222222222222222222222222222222222222222
UNION ALL -- 1st TOTAL
--2222222222222222222222222222222222222222222222222222222222222222222222222222222222
select 2
     , CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 11
              ElSE 2
         END
            ELSE 
              CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 31
                ElSE 21
              END              
       END  
     , CASE WHEN month(G.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)))
       END  
     , CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
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
     , 'TOTAL:'             
     , ISNULL(SUM(G.MB_RESERVE_AMT), 0) + ISNULL(SUM(G.MB_WRK_PAY_REFUND), 0) - ISNULL(SUM(G.MB_WRK_PAY_TOT_AMT), 0) "O/S Reserve" 
     --, ISNULL(SUM(G.MB_WRK_PAY_RECOVER), 0) Recovery
     , ISNULL(SUM(G.MB_WRK_PAY_TOT_AMT), 0) paid
FROM
(                                   -----------------3
select 1,
       D.MB_CLM_NBR MB_CLM_NBR
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
     , D.MB_OCC_DT MB_OCC_DT
--     , sum(max(D.MB_RESERVE_AMT)) + sum(F.MB_WRK_PAY_REFUND) - sum(F.MB_WRK_PAY_TOT_AMT) "O/S Reserve"
--     , sum(F.MB_WRK_PAY_TOT_AMT) Paid
from
(                                   ------------------2
select D.MB_CLM_NBR MB_CLM_NBR
     , D.MB_COVERAGE_ID MB_COVERAGE_ID
     , D.MB_COVRG_CODE MB_COVRG_CODE
     , D.MB_PROCESS_ID MB_PROCESS_ID      
     , sum(E.MB_RESERVE_AMT) MB_RESERVE_AMT
     --, sum(E.MB_CLM_PAID_AMT) MB_CLM_PAID_AMT
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT
from       
(                                   ------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT
FROM PS_MB_CLM_PER_TBL A, PS_MB_JOB_VW B 
  WHERE B.EMPLID = A.EMPLID
     AND B.EMPL_RCD = A.EMPL_RCD
     AND B.EFFDT =
        (SELECT MAX(B_ED.EFFDT) FROM PS_MB_JOB_VW B_ED
        WHERE B.EMPLID = B_ED.EMPLID
          AND B.EMPL_RCD = B_ED.EMPL_RCD
          AND B_ED.EFFDT <= SUBSTRING(CONVERT(CHAR,GETDATE(),102), 1, 10))
    AND B.EFFSEQ =
        (SELECT MAX(B_ES.EFFSEQ) FROM PS_MB_JOB_VW B_ES
        WHERE B.EMPLID = B_ES.EMPLID
          AND B.EMPL_RCD = B_ES.EMPL_RCD
          AND B.EFFDT = B_ES.EFFDT)
    AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --And A.MB_CLM_NBR = '900114954'
  --And A.EMPLID = 'C03760'
--AND A.MB_WRK_CASE_STATUS <> 'C'
--AND A.MB_NCCI_INJ_CD <> '5'  
AND A.MB_NCCI_INJ_CD <> ''
) A                                 ------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_COVRG_CODE IN ('EXPENS','INDEMN','LEGAL','MEDICA','OTHER')
  AND D.MB_CLM_NBR  = A.MB_CLM_NBR
  AND D.MB_PROCESS_ID = E.MB_PROCESS_ID
  AND D.MB_COVERAGE_ID = E.MB_COVERAGE_ID
  AND D.MB_CLM_NBR = E.MB_CLM_NBR
group by D.MB_CLM_NBR
       , D.MB_COVERAGE_ID
       , D.MB_COVRG_CODE
       , D.MB_PROCESS_ID
       , A.MB_WRK_CASE_STATUS
       , A.MB_NCCI_INJ_CD            
       , A.MB_OCC_DT
) D                                -------------------2 end
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
       , D.MB_OCC_DT
--order by 2,4,1



UNION ALL


------------------------------------------------------------------------------------
--- BELOW FOR DUMMIES
------------------------------------------------------------------------------------
select 1,
       D.MB_CLM_NBR MB_CLM_NBR
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
     , D.MB_OCC_DT MB_OCC_DT
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
     , A.MB_OCC_DT MB_OCC_DT
from       
(------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT 
FROM PS_MB_CLM_PER_TBL A
  WHERE A.EMPLID = 'DUMMY'
  AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --AND A.MB_NCCI_INJ_CD <> ''
) A --------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_COVRG_CODE IN ('EXPENS','INDEMN','LEGAL','MEDICA','OTHER')
  AND D.MB_CLM_NBR  = A.MB_CLM_NBR
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
       , A.MB_OCC_DT                   
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
       , D.MB_OCC_DT     
--order by 2,4,1 
------------------------------------------------------------------------------------
--END DUMMIES
------------------------------------------------------------------------------------
) G                                ------------------3 end      
GROUP BY MB_WRK_CASE_STATUS
       , MB_NCCI_INJ_CD
       --, MB_COVRG_CODE
       , CASE WHEN month(G.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)))
         END
--2222222222222222222222222222222222222222222222222222222222222222222222222222222222
-------------------------END END END END END END END--------------------------------
--2222222222222222222222222222222222222222222222222222222222222222222222222222222222         
         
         


--3333333333333333333333333333333333333333333333333333333333333333333333333333333333
UNION ALL        -- RECOVERY
--3333333333333333333333333333333333333333333333333333333333333333333333333333333333
select 3 rowid
     , CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 12
              ElSE 3
         END
            ELSE 
              CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 32
                ElSE 22
              END              
       END  rowid2
     , CASE WHEN month(G.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)))
       END  fy_year
     , CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Lost Time' 
              ElSE 'Open Lost Time'
         END
            ELSE 
              CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Medical Only' 
                ElSE 'Open Medical Only'
              END              
       END 
       --|| ' ' || convert(varchar(10), COUNT(DISTINCT(G.MB_CLM_NBR))) 
       || ' Claims'  claim_type
     , 'RECOVERY:'             
     , 0--ISNULL(SUM(G.MB_RESERVE_AMT) + SUM(G.MB_WRK_PAY_REFUND) - SUM(G.MB_WRK_PAY_TOT_AMT), 0) "O/S Reserve" 
     , ISNULL(SUM(G.MB_WRK_PAY_RECOVER), 0)*-1 Recovery
FROM
(                                   -----------------3
select 1,
       D.MB_CLM_NBR MB_CLM_NBR
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
     , D.MB_OCC_DT MB_OCC_DT
--     , sum(max(D.MB_RESERVE_AMT)) + sum(F.MB_WRK_PAY_REFUND) - sum(F.MB_WRK_PAY_TOT_AMT) "O/S Reserve"
--     , sum(F.MB_WRK_PAY_TOT_AMT) Paid
from
(                                   ------------------2
select D.MB_CLM_NBR MB_CLM_NBR
     , D.MB_COVERAGE_ID MB_COVERAGE_ID
     , D.MB_COVRG_CODE MB_COVRG_CODE
     , D.MB_PROCESS_ID MB_PROCESS_ID      
     , sum(E.MB_RESERVE_AMT) MB_RESERVE_AMT
     --, sum(E.MB_CLM_PAID_AMT) MB_CLM_PAID_AMT
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT
from       
(                                   ------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT
FROM PS_MB_CLM_PER_TBL A, PS_MB_JOB_VW B 
  WHERE B.EMPLID = A.EMPLID
     AND B.EMPL_RCD = A.EMPL_RCD
     AND B.EFFDT =
        (SELECT MAX(B_ED.EFFDT) FROM PS_MB_JOB_VW B_ED
        WHERE B.EMPLID = B_ED.EMPLID
          AND B.EMPL_RCD = B_ED.EMPL_RCD
          AND B_ED.EFFDT <= SUBSTRING(CONVERT(CHAR,GETDATE(),102), 1, 10))
    AND B.EFFSEQ =
        (SELECT MAX(B_ES.EFFSEQ) FROM PS_MB_JOB_VW B_ES
        WHERE B.EMPLID = B_ES.EMPLID
          AND B.EMPL_RCD = B_ES.EMPL_RCD
          AND B.EFFDT = B_ES.EFFDT)
    AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --And A.MB_CLM_NBR = '900114954'
  --And A.EMPLID = 'C03760'
--AND A.MB_WRK_CASE_STATUS <> 'C'
--AND A.MB_NCCI_INJ_CD <> '5'  
AND A.MB_NCCI_INJ_CD <> ''
) A                                 ------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_COVRG_CODE IN ('EXPENS','INDEMN','LEGAL','MEDICA','OTHER')
  AND D.MB_CLM_NBR  = A.MB_CLM_NBR
  AND D.MB_PROCESS_ID = E.MB_PROCESS_ID
  AND D.MB_COVERAGE_ID = E.MB_COVERAGE_ID
  AND D.MB_CLM_NBR = E.MB_CLM_NBR
group by D.MB_CLM_NBR
       , D.MB_COVERAGE_ID
       , D.MB_COVRG_CODE
       , D.MB_PROCESS_ID
       , A.MB_WRK_CASE_STATUS
       , A.MB_NCCI_INJ_CD            
       , A.MB_OCC_DT
) D                                -------------------2 end
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
       , D.MB_OCC_DT
--order by 2,4,1



UNION ALL


------------------------------------------------------------------------------------
--- BELOW FOR DUMMIES
------------------------------------------------------------------------------------
select 1,
       D.MB_CLM_NBR MB_CLM_NBR
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
     , D.MB_OCC_DT MB_OCC_DT
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
     , A.MB_OCC_DT MB_OCC_DT
from       
(------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT 
FROM PS_MB_CLM_PER_TBL A
  WHERE A.EMPLID = 'DUMMY'
  AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --AND A.MB_NCCI_INJ_CD <> ''
) A --------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_COVRG_CODE IN ('EXPENS','INDEMN','LEGAL','MEDICA','OTHER')
  AND D.MB_CLM_NBR  = A.MB_CLM_NBR
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
       , A.MB_OCC_DT                     
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
       , D.MB_OCC_DT     
--order by 2,4,1 
------------------------------------------------------------------------------------
--END DUMMIES
------------------------------------------------------------------------------------
) G                                ------------------3 end      
GROUP BY MB_WRK_CASE_STATUS
       , MB_NCCI_INJ_CD
       --, MB_COVRG_CODE
       , CASE WHEN month(G.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)))
         END
--3333333333333333333333333333333333333333333333333333333333333333333333333333333333
---------------------------END END END END END END END------------------------------
--3333333333333333333333333333333333333333333333333333333333333333333333333333333333
                  
--4444444444444444444444444444444444444444444444444444444444444444444444444444444444
UNION ALL -- 2nd TOTAL
--4444444444444444444444444444444444444444444444444444444444444444444444444444444444
select 2
     , CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 13
              ElSE 4
         END
            ELSE 
              CASE WHEN G.MB_WRK_CASE_STATUS = 'C' THEN 33
                ElSE 23
              END              
       END  
     , CASE WHEN month(G.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)))
       END  
     , CASE WHEN G.MB_NCCI_INJ_CD = '5' THEN
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
     , 'TOTAL INC:'
     , 0             
--     , ISNULL(SUM(G.MB_RESERVE_AMT) + SUM(G.MB_WRK_PAY_REFUND) - SUM(G.MB_WRK_PAY_TOT_AMT), 0) "O/S Reserve" 
     --, ISNULL(SUM(G.MB_WRK_PAY_RECOVER), 0) Recovery
     , ISNULL(SUM(G.MB_RESERVE_AMT), 0) + ISNULL(SUM(G.MB_WRK_PAY_REFUND), 0) - ISNULL(SUM(G.MB_WRK_PAY_TOT_AMT), 0)
     + (ISNULL(SUM(G.MB_WRK_PAY_TOT_AMT), 0))
     - (ISNULL(SUM(G.MB_WRK_PAY_RECOVER), 0))
FROM
(                                   -----------------3
select 1,
       D.MB_CLM_NBR MB_CLM_NBR
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
     , D.MB_OCC_DT MB_OCC_DT
--     , sum(max(D.MB_RESERVE_AMT)) + sum(F.MB_WRK_PAY_REFUND) - sum(F.MB_WRK_PAY_TOT_AMT) "O/S Reserve"
--     , sum(F.MB_WRK_PAY_TOT_AMT) Paid
from
(                                   ------------------2
select D.MB_CLM_NBR MB_CLM_NBR
     , D.MB_COVERAGE_ID MB_COVERAGE_ID
     , D.MB_COVRG_CODE MB_COVRG_CODE
     , D.MB_PROCESS_ID MB_PROCESS_ID      
     , sum(E.MB_RESERVE_AMT) MB_RESERVE_AMT
     --, sum(E.MB_CLM_PAID_AMT) MB_CLM_PAID_AMT
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT
from       
(                                   ------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT
FROM PS_MB_CLM_PER_TBL A, PS_MB_JOB_VW B 
  WHERE B.EMPLID = A.EMPLID
     AND B.EMPL_RCD = A.EMPL_RCD
     AND B.EFFDT =
        (SELECT MAX(B_ED.EFFDT) FROM PS_MB_JOB_VW B_ED
        WHERE B.EMPLID = B_ED.EMPLID
          AND B.EMPL_RCD = B_ED.EMPL_RCD
          AND B_ED.EFFDT <= SUBSTRING(CONVERT(CHAR,GETDATE(),102), 1, 10))
    AND B.EFFSEQ =
        (SELECT MAX(B_ES.EFFSEQ) FROM PS_MB_JOB_VW B_ES
        WHERE B.EMPLID = B_ES.EMPLID
          AND B.EMPL_RCD = B_ES.EMPL_RCD
          AND B.EFFDT = B_ES.EFFDT)
    AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --And A.MB_CLM_NBR = '900114954'
  --And A.EMPLID = 'C03760'
--AND A.MB_WRK_CASE_STATUS <> 'C'
--AND A.MB_NCCI_INJ_CD <> '5'  
AND A.MB_NCCI_INJ_CD <> ''
) A                                 ------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_COVRG_CODE IN ('EXPENS','INDEMN','LEGAL','MEDICA','OTHER')
  AND D.MB_CLM_NBR  = A.MB_CLM_NBR
  AND D.MB_PROCESS_ID = E.MB_PROCESS_ID
  AND D.MB_COVERAGE_ID = E.MB_COVERAGE_ID
  AND D.MB_CLM_NBR = E.MB_CLM_NBR
group by D.MB_CLM_NBR
       , D.MB_COVERAGE_ID
       , D.MB_COVRG_CODE
       , D.MB_PROCESS_ID
       , A.MB_WRK_CASE_STATUS
       , A.MB_NCCI_INJ_CD            
       , A.MB_OCC_DT
) D                                -------------------2 end
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
       , D.MB_OCC_DT
--order by 2,4,1



UNION ALL


------------------------------------------------------------------------------------
--- BELOW FOR DUMMIES
------------------------------------------------------------------------------------
select 1,
       D.MB_CLM_NBR MB_CLM_NBR
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
     , D.MB_OCC_DT MB_OCC_DT
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
     , A.MB_OCC_DT MB_OCC_DT
from       
(------------------1
Select A.MB_CLM_NBR MB_CLM_NBR
     , A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     , A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
     , A.MB_OCC_DT MB_OCC_DT 
FROM PS_MB_CLM_PER_TBL A
  WHERE A.EMPLID = 'DUMMY'
  AND A.MB_OCC_DT between  '1974-07-01' and  '1975-06-30'
  --AND A.MB_NCCI_INJ_CD <> ''
) A --------------------1 end
   , PS_MB_CVRG_RES_TBL D
   , PS_MB_CVG_RESR_TBL E
where D.MB_COVRG_CODE IN ('EXPENS','INDEMN','LEGAL','MEDICA','OTHER')
  AND D.MB_CLM_NBR  = A.MB_CLM_NBR
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
       , A.MB_OCC_DT                   
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
       , D.MB_OCC_DT     
--order by 2,4,1 
------------------------------------------------------------------------------------
--END DUMMIES
------------------------------------------------------------------------------------
) G                                ------------------3 end      
GROUP BY MB_WRK_CASE_STATUS
       , MB_NCCI_INJ_CD
       --, MB_COVRG_CODE
       , CASE WHEN month(G.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(G.MB_OCC_DT)))
         END
--4444444444444444444444444444444444444444444444444444444444444444444444444444444444
-------------------------END END END END END END END--------------------------------
--4444444444444444444444444444444444444444444444444444444444444444444444444444444444

         
         
)HH                                -----------------4 end
order by 3,2         
