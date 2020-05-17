select count(1) from 
ps_mb_job_vw a,
(
select max(a_es.effseq) effseq, A_ES.EMPLID EMPLID, A_ES.EMPL_RCD EMPL_RCD, A_ES.EFFDT EFFDT
from ps_mb_job_vw a_es,
(
SELECT MAX(A_ed.EFFDT) max_effdt, A_ed.emplid emplid, A_ed.empl_rcd empl_rcd
FROM PS_MB_JOB_VW A_ed
WHERE 1=1
AND A_ed.EFFDT <= TO_DATE('2012-07-01','YYYY-MM-DD')
--AND A_ed.EMPL_STATUS IN ('A','L','P') 
--AND A_ed.JOBCODE <> '200300'
group by A_ed.emplid, A_ed.empl_rcd
) a1
WHERE A1.EMPLID   = A_ES.EMPLID 
AND A1.EMPL_RCD   = A_ES.EMPL_RCD 
AND A1.max_effdt  = A_ES.EFFDT  
group by A_ES.EFFDT, A_ES.EMPLID, A_ES.EMPL_RCD
) a2,
--
    --(
    --select b.position_nbr 
    --from PS_POSITION_DATA b,
    (
    SELECT MAX(B_ED.EFFDT) EFFDT, b_ed.position_nbr position_nbr
    FROM PS_POSITION_DATA B_ED 
    WHERE 1=1
    --AND B.POSITION_NBR = B_ED.POSITION_NBR 
    AND B_ED.EFFDT <= TO_DATE('2012-07-01','YYYY-MM-DD')
    group by b_ed.position_nbr
    ) b2,--b1
    --where b.effdt      = b1.effdt  
    --and b.position_nbr = b1.position_nbr
    --) b2,
--
        (
        SELECT MAX(E_ED.EFFDT) EFFDT, E_ED.SETID SETID,E_ED.JOBCODE JOBCODE
        FROM PS_JOBCODE_TBL E_ED, 
        (
        SELECT MAX(A_ED.EFFDT) effdt, A_ED.EMPLID emplid,A_ED.EMPL_RCD empl_rcd ,A_ed.jobcode jobcode  
        FROM PS_MB_JOB_VW A_ED 
        where 1=1        
        AND A_ED.EFFDT <= TO_DATE('2012-07-01','YYYY-MM-DD')
        --AND A_ed.EMPL_STATUS IN ('A','L','P')
        --AND A_ed.JOBCODE <> '200300'
        group by A_ED.EMPLID,A_ED.EMPL_RCD,A_ed.jobcode
        )ilv_jv1
        where 1=1
        and E_ED.jobcode = ilv_jv1.jobcode
        and E_ED.EFFDT <= ilv_jv1.EFFDT
        group by E_ED.SETID,E_ED.JOBCODE   
        ) c2,
--        
            (
            SELECT MAX(F_ED.EFFDT) EFFDT, F_ED.SETID SETID,F_ED.SAL_ADMIN_PLAN SAL_ADMIN_PLAN,F_ED.GRADE GRADE
            FROM PS_SAL_GRADE_TBL F_ED, 
            (SELECT MAX(A_ED.EFFDT) effdt, A_ED.EMPLID emplid,A_ED.EMPL_RCD empl_rcd ,A_ed.GRADE grade,A_ed.SAL_ADMIN_PLAN SAL_ADMIN_PLAN  
            FROM PS_MB_JOB_VW A_ED 
            where 1=1            
            AND A_ED.EFFDT <= TO_DATE('2012-07-01','YYYY-MM-DD')
            --AND A_ed.EMPL_STATUS IN ('A','L','P')
            --AND A_ed.JOBCODE <> '200300'
            group by A_ED.EMPLID,A_ED.EMPL_RCD,A_ed.GRADE,A_ed.SAL_ADMIN_PLAN  
            ) ilv_jv       
            where 1=1
            AND f_ed.GRADE = ilv_jv.GRADE 
            AND F_ed.SAL_ADMIN_PLAN = ilv_jv.SAL_ADMIN_PLAN 
            AND F_ED.EFFDT <= ilv_jv.EFFDT
            group by F_ED.SETID,F_ED.SAL_ADMIN_PLAN,F_ED.GRADE 
            ) d2,
--            
                (
                SELECT MAX(G_ED.EFFDT) EFFDT, g_ed.union_cd union_cd, ilv_pd.position_nbr position_nbr
                FROM PS_UNION_TBL G_ED,
                (SELECT b_ed.union_cd union_cd, MAX(B_ED.EFFDT) effdt, b_ed.position_nbr position_nbr
                FROM PS_POSITION_DATA B_ED
                WHERE 1=1--B.POSITION_NBR = B_ED.POSITION_NBR
                AND B_ED.EFFDT <= TO_DATE('2012-07-01','YYYY-MM-DD')
                group by B_ED.POSITION_NBR, b_ed.union_cd
                ) ilv_pd 
                WHERE 1=1
                and ilv_pd.union_cd = G_ED.union_cd 
                AND G_ED.EFFDT <= ilv_pd.effdt
                group by G_ED.UNION_CD, ilv_pd.position_nbr
                ) e2
--                
where a.EMPLID = a2.EMPLID
and a.EMPL_RCD = a2.EMPL_RCD
and a.effdt    = a2.EFFDT
and a.effseq   = a2.effseq
AND A.JOBCODE <> '200300'
AND A.EMPL_STATUS IN ('A','L','P')
-- group by  a.EMPLID, a.EMPL_RCD, a.effdt, a.effseq 
--
and a.position_nbr = b2.position_nbr
--
and a.jobcode=c2.jobcode
--
AND A.GRADE = d2.GRADE 
AND A.SAL_ADMIN_PLAN = d2.SAL_ADMIN_PLAN    
--
                AND  a.position_nbr = e2.position_nbr
    
    
    
select * from PS_MB_JOB_VW
where emplid = '17407'

and empl_rcd = 0

and empl_status


17407    0    11/1/2009    0    A
69872    0    11/1/2009    0    A