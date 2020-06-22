--GIVEN TABLE REFERENCES ALL THE OTHER TABLES
select * from 
( 
select  max(uc.constraint_name) -- use max here if you use group by for this query
, '('||ucc1.table_name||'.'||ucc1.column_name||')' "constraint_source_table.column" --,       'REFERENCES'||CHR(10)
,      '('||ucc2.table_name||'.'||ucc2.column_name||')' "references_table.column"
, NULL Search_condition
from user_constraints uc,
     user_cons_columns ucc1,
     user_cons_columns ucc2
where uc.constraint_name = ucc1.constraint_name
and ucc1.position = ucc2.position
AND uc.r_constraint_name = ucc2.constraint_name
and uc. table_name = :enter_table
-- Check the query by commenting the next line for all the results
--and substr(ucc1.column_name, instr(ucc1.column_name,'_',-1,2)+1) = substr(ucc2.column_name, instr(ucc2.column_name,'_',-1,2)+1) 
group by '('||ucc1.table_name||'.'||ucc1.column_name||')', '('||ucc2.table_name||'.'||ucc2.column_name||')'
UNION ALL
select  uc.constraint_name -- use max here if you use group by for this query
, '('||ucc1.table_name||'.'||ucc1.column_name||')' "constraint_source_table.column" --,       'REFERENCES'||CHR(10)
, NULL "references_table.column"
, uc. search_condition -- use max here if you use group by for this query
from user_constraints uc,
     user_cons_columns ucc1
where uc.constraint_name = ucc1.constraint_name
and uc. table_name = :enter_table 
-- Check the query by commnting the next line for all the results
and search_condition is not null
UNION ALL
select uc.constraint_name -- use max here if you use group by for this query
, '('||ucc1.table_name||'.'||ucc1.column_name||')' "constraint_source_table.column" --,       'REFERENCES'||CHR(10)
, '('||ucc2.table_name||'.'||ucc2.column_name||')' "references_table.column"
, uc. search_condition -- use max here if you use group by for this query
from user_constraints uc,
     user_cons_columns ucc1,
     user_cons_columns ucc2
where uc.constraint_name = ucc1.constraint_name
AND uc.r_constraint_name = ucc2.constraint_name(+)
and uc. table_name = :enter_table
and uc.constraint_name not in (select  distinct uc.constraint_name 
                                     from user_constraints uc,
                                          user_cons_columns ucc1,
                                          user_cons_columns ucc2
                                     where uc.constraint_name = ucc1.constraint_name
                                     AND ucc1.position = ucc2.position
                                     AND uc.r_constraint_name = ucc2.constraint_name
                                     AND uc. table_name = :enter_table                                                                         
                              )
AND search_condition is null 
)
order by 1,3;




--ALL THE TABLES REFERENCE THE GIVEN TABLE
select * from
(
select  max(uc.constraint_name) -- use max here if you use group by for this query
, '('||ucc1.table_name||'.'||ucc1.column_name||')' "constraint_source_table.column" --,       'REFERENCES'||CHR(10)
,      '('||ucc2.table_name||'.'||ucc2.column_name||')' "references_table.column"
--, NULL Search_condition
from user_constraints uc,
     user_cons_columns ucc1,
     user_cons_columns ucc2
where uc.constraint_name = ucc1.constraint_name
and ucc1.position = ucc2.position
AND uc.r_constraint_name = ucc2.constraint_name
and ucc2. table_name = :enter_table
-- Check the query by commenting the next line for all the results
--and substr(ucc1.column_name, instr(ucc1.column_name,'_',-1,2)+1) = substr(ucc2.column_name, instr(ucc2.column_name,'_',-1,2)+1) 
group by '('||ucc1.table_name||'.'||ucc1.column_name||')', '('||ucc2.table_name||'.'||ucc2.column_name||')'
)
order by 1,3;


