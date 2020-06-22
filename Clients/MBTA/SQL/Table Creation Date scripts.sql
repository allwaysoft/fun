select  object_name, created from user_objects where object_type='TABLE'
order by created desc

select * from all_tables 
where table_name like 'DC%'
order by last_analyzed desc

--where last_analyzed = :date

select * from all_objects
where 1=1 
--owner <> 'SYS'
and object_name like 'TABLE%'

select * from user_objects