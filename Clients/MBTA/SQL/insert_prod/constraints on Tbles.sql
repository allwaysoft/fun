select owner,constraint_name,constraint_type,table_name,r_owner,r_constraint_name
   from all_constraints where constraint_type in ('P','U') and table_name='BPBANKS';

-- R_CONSTRAINT_NAME COLUMN is the constraint refered by CONSTRAINT_NAME COLUMN in other table
select * from all_constraints where table_name = 'ACCOUNT'





-- MAIN QUERY TO KNOW ALL THE CONSTRAINTS OF A GIVEN TABLE'S REFERENCES TO OTHER TABLES. 
-- TWEAK IT ACCORDINGLY TO GET THE REQUIRED DATA
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
order by 1,3





-- MAIN QUERY TO KNOW ALL THE CONSTRAINTS OF ALL THE TABLES REFERENCES TO A GIVEN TABLES. 
-- TWEAK IT ACCORDINGLY TO GET THE REQUIRED DATA
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
and ucc2. table_name = :enter_table
-- Check the query by commenting the next line for all the results
--and substr(ucc1.column_name, instr(ucc1.column_name,'_',-1,2)+1) = substr(ucc2.column_name, instr(ucc2.column_name,'_',-1,2)+1) 
group by '('||ucc1.table_name||'.'||ucc1.column_name||')', '('||ucc2.table_name||'.'||ucc2.column_name||')'
)
order by 1,3




SELECT * FROM ALL_CONS_COLUMNS A JOIN ALL_CONSTRAINTS C  ON A.CONSTRAINT_NAME = C.CONSTRAINT_NAME 
WHERE C.TABLE_NAME = 'BPVENDORS' AND C.CONSTRAINT_TYPE = 'R'

select uc.r_constraint_name, uc.constraint_name, ucc1.table_name, ucc1.column_name
from user_constraints uc,
     user_cons_columns ucc1
where uc. table_name = 'BPVENDORS'
and   uc.constraint_name = ucc1.constraint_name
group by uc.constraint_name, ucc1.table_name, ucc1.column_name, uc.r_constraint_name

Select * from user_tables where table_name like '%CURR%'

select *  from user_constraints uc where uc. table_name = 'BPVENDORS'
select * from user_cons_columns where constraint_name = 'BPVENDORS_ARTAX_FK5'

SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      uc.constraint_type = 'R'
AND      uc.constraint_name = UPPER('&input_constraint_name');

SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      uc.constraint_type = 'R'
ORDER BY ucc1.table_name
,        uc.constraint_name;

select * from bpvendors

select * from user_constraints where table_name = 'COMPANY'
select * from user_cons_columns where table_name = 'COMPANY'
select * from user_cons_columns where constraint_name = 'COMPANY_PERIOD_FK'--'PERIOD_PK'
select * from user_cons_columns where constraint_name = 'SYS_C0042373'
union all
select * from user_cons_columns where constraint_name = 'SYS_C0042372'
select * from terr


select * from period