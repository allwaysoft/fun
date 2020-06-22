select year(A.col1)
     , A.ord
     , A.claim_type
     , sum(A.MB_CLM_NBR)
from
(
Select CASE WHEN month(A.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(A.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(A.MB_OCC_DT)))
       END col1
     , CASE WHEN A.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 2
              ElSE 1
         END
            ELSE 
              CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 4
                ElSE 3
              END              
       END ord       
     , CASE WHEN A.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Lost Time' 
              ElSE 'Open Lost Time'
         END
            ELSE 
              CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Medical Only' 
                ElSE 'Open Medical Only'
              END              
       END 
       --|| ' ' || convert(varchar(10), COUNT(DISTINCT(G.MB_CLM_NBR))) 
       || ' Claims' claim_type        
--|| ' ACTUAL' col1, 
     , count(A.MB_CLM_NBR) MB_CLM_NBR
     --, A.MB_WRK_CASE_STATUS MB_WRK_CASE_STATUS
     --, A.MB_NCCI_INJ_CD MB_NCCI_INJ_CD
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
    AND A.MB_OCC_DT between  '1964-07-01' and  '2011-06-30'
AND A.MB_NCCI_INJ_CD <> ''
group by CASE WHEN month(A.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(A.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(A.MB_OCC_DT)))
	     END
     , CASE WHEN A.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 2
              ElSE 1
         END
            ELSE 
              CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 4
                ElSE 3
              END              
       END 	     
     , CASE WHEN A.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Lost Time' 
              ElSE 'Open Lost Time'
         END
            ELSE 
              CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Medical Only' 
                ElSE 'Open Medical Only'
              END              
       END 
       --|| ' ' || convert(varchar(10), COUNT(DISTINCT(G.MB_CLM_NBR))) 
       || ' Claims' 	     
	     
	     
	     
UNION ALL



Select CASE WHEN month(A.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(A.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(A.MB_OCC_DT)))
	   END
     , CASE WHEN A.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 2
              ElSE 1
         END
            ELSE 
              CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 4
                ElSE 3
              END              
       END 	   
     , CASE WHEN A.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Lost Time' 
              ElSE 'Open Lost Time'
         END
            ELSE 
              CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Medical Only' 
                ElSE 'Open Medical Only'
              END              
       END 
       --|| ' ' || convert(varchar(10), COUNT(DISTINCT(G.MB_CLM_NBR))) 
       || ' Claims' 
     , count(distinct(A.MB_CLM_NBR)) count_YD
FROM PS_MB_CLM_PER_TBL A--, PS_MB_JOB_VW B 
  WHERE  A.EMPLID = 'DUMMY'
    AND A.MB_OCC_DT between  '1964-07-01' and  '2011-06-30'
group by CASE WHEN month(A.MB_OCC_DT) >= 7 THEN convert(date, "01/01/" + convert(char(4),year(A.MB_OCC_DT)+1))
	       ELSE convert(date, "01/01/" + convert(char(4),year(A.MB_OCC_DT)))
	   END
     , CASE WHEN A.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 2
              ElSE 1
         END
            ELSE 
              CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 4
                ElSE 3
              END              
       END 	   
     , CASE WHEN A.MB_NCCI_INJ_CD = '5' THEN
         CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Lost Time' 
              ElSE 'Open Lost Time'
         END
            ELSE 
              CASE WHEN A.MB_WRK_CASE_STATUS = 'C' THEN 'Closed Medical Only' 
                ElSE 'Open Medical Only'
              END              
       END 
       --|| ' ' || convert(varchar(10), COUNT(DISTINCT(G.MB_CLM_NBR))) 
       || ' Claims' 	       
) A   
group by year(A.col1), A.claim_type, A.ord
order by 1,2