select rownum as rank, a.*
from (
select round(elapsed_Time/1000000,2) elap_time,
sar.*
from  gv$sqlarea sar
where elapsed_time/1000000 > 5
order by elapsed_time desc) a
where rownum < 11

https://oraclefact.wordpress.com/2018/08/30/top-10-sql-query-sqlarea/