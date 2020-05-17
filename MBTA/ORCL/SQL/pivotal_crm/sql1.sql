SELECT text 
FROM all_source 
WHERE name='TMP_ORDERS_BF_I_TRG' 
ORDER BY line

select object_type, count(1) 
from dba_objects where owner = 'BOSED' 
group by object_type
order by count(1) desc

select table_name, num_rows 
from dba_tables 
where owner = 'BOSED' 
order by num_rows desc
