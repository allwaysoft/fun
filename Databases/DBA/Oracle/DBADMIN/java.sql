select * from all_objects where lower(object_name) like 'keyadmin'

select 

select * from sys.all_objects where object_type = 'USER'

select distinct object_type from all_objects

SELECT   object_name,    object_type,    status,    timestamp FROM    user_objects WHERE    (object_name NOT LIKE 'SYS_%' AND     object_name NOT LIKE 'CREATE$%' AND     object_name NOT LIKE 'JAVA$%' AND     object_name NOT LIKE 'LOADLOB%') AND   object_type LIKE 'JAVA %' ORDER BY   object_type,    object_name; 

select * from dba_source where name = 'SCRAMBLE_PL_SQL'

select * from dba_source where type = 'JAVA SOURCE'

select * from dba_source where owner = 'KEYADMIN'

select * from user_source where name = 'SCRAMBLE_PL_SQL'

select * from dba_JAVA_CLASSES where upper(name) like '%SCRAMBLE_PL_SQL%'


select * from all_source where type = 'JAVA SOURCE'

ALL_JAVA_ARGUMENTS
ALL_JAVA_CLASSES
ALL_JAVA_DERIVATIONS
ALL_JAVA_FIELDS
ALL_JAVA_IMPLEMENTS
ALL_JAVA_INNERS
ALL_JAVA_LAYOUTS
ALL_JAVA_METHODS
ALL_JAVA_NCOMPS
ALL_JAVA_RESOLVERS
all_java_throws
ALL_SOURCE