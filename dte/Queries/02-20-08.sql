select /*+ PARALLEL(ccs_account_dispatch_history, 16 */ cadh_cad_id, count(cadh_cad_id) 
from ccs_account_dispatch_history
where cadh_send_date is null
group by cadh_cad_id
order by count(cadh_cad_id) desc

1136587