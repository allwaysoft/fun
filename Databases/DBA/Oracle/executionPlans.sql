Execution Plans
view SQL plans of SQL in various scenarios.
/**** Get SQL execution plan information which is still available in SHARED POOL ****/
–get sql id from sql text
select * from v$sql where sql_text like ‘with pri_detai%’;

–get the latest plan_hash_value and other plan details used by SQL
select sql_id, PLAN_HASH_VALUE, max(to_char(timestamp,’DD-MON-YYYY HH24:MI:SS’)) Timestamp
from v$sql_plan
where sql_id= ‘&sqlid’
group by sql_id, PLAN_HASH_VALUE;

–get the execution plan based on the sqlid
FORMAT=> ‘TYPICAL +outline’ This option for format gives the outline data. In outline data, the “LEADING” section provides the join order used by the SQL
'TYPICAL +peeked_binds' This option as name suggests shows the bind variables of the SQL slong with the execution plan
cursor_child_no use this when there are more than one plans for the same sql_id
SELECT * from table(DBMS_XPLAN.DISPLAY_CURSOR(sql_id => ‘&sqlid’, cursor_child_no => ‘&chld’, plan_hash_value => ‘&phv’, format => ‘&format’));

/**** Get SQL execution plan information which is out of SHARED POOL and in AWR ****/
–get sql id from sql text
select * from dba_hist_sqltext where sql_text like ‘with pri_detai%’;

–get the latest plan_hash_value used by SQL
select sql_id, PLAN_HASH_VALUE, max(to_char(timestamp,’DD-MON-YYYY HH24:MI:SS’)) Timestamp
from DBA_HIST_SQL_PLAN
where sql_id= ’7rxh365jpp33w’
group by sql_id, PLAN_HASH_VALUE;

–get the execution plan based on the sqlid
–FORMAT=> ‘TYPICAL +outline’); This option for format gives the outline data. Inoutline data, the “LEADING” section provides the join order useed by the SQL
select * from TABLE(DBMS_XPLAN.DISPLAY_AWR(sql_id => ‘&sqlid’, plan_hash_value => ‘&phv’, format => ‘&format’));

Other ways of getting Execution plans
https://blogs.oracle.com/sql/how-to-create-an-execution-plan
 
 Finding and tuning high resource usage SQL
http://perranganos.blogspot.com/2012/01/tanel-poder-snapper-brilliant.html –This link shows how to identify the SQL

https://github.com/tanelpoder/tpt-oracle –This link has all the scripts used by Tanel Poder, including the once used in above link to identify SQL.

All about execution plans by Jonathan Lewis
http://allthingsoracle.com/author/jonathan-lewis/