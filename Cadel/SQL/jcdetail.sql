select distinct jcdt_cat_code from jcdetail

select jcdt_comp_code, '00', jcdt_job_code, replace(jcdt_phs_code,'-',','), jcdt_cat_code, --jcdt_acc_code,
       jhp_name, sysdate, SUM(jcdt_amt) amt
from jcdetail det,
--     jcjob job, 
     jcjobhphs phs
where jcdt_comp_code = :company_code
and CASE 
        WHEN JCDT_TYPE_CODE = 'O' 
        AND trunc(jcdt_post_date) <= trunc(sysdate)--:post_date  
        THEN 'A'
        WHEN JCDT_TYPE_CODE = 'C' 
        AND trunc(jcdt_post_date) <= trunc(sysdate)--:post_date
        AND jcdt_src_comm_code IS NULL then 'B'
        END IN ('A','B')
and det.jcdt_comp_code = phs.jhp_comp_code
and det.jcdt_job_code    = phs.jhp_job_code
and det.jcdt_phs_code    = phs.jhp_code
group by jcdt_comp_code, 00, jcdt_job_code, jcdt_phs_code, jcdt_cat_code, --jcdt_acc_code,
       jhp_name
 
 = 'S'
  
select * from jcdetail where trunc(jcdt_post_date) = to_date('08-12-08','mm-dd-yy')
  
select * from jcjobhphs 
group by jhp_comp_code, jhp_job_code
group
for each cat_code
if JCDT_TYPE_CODE = 'O' 
and in the range of jcdt_post_date get jcdt_amt

if JCDT_TYPE_CODE = 'C' and in the rage of post_date 06-30-2009
and jcdt_src_comm_code is null

select * from jcdetail

get the name from jcjobhphs

select distinct jcdt_type_code from jcdetail

--= job_comp_code
--= job_code
--and job.comp_code        
--and job.job_code         
--where jcdt_job_code = '90720' 
--and jcdt_phs_code = '022-00810'