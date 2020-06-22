/*
--Some Acadian specific procedure
accounting.dbo.sp_get_environment
*/--Find an object in all the databases of an instance
    EXEC sp_MSforeachdb
    'if exists(select 1 from [?].sys.objects where name=''ChangeLog'') --Change here
    select ''?'' as FoundInDatabase, * from [?].sys.objects where name=''ChangeLog''' --Change hereEXEC sp_MSforeachdb
'if exists(select 1 from [?].sys.objects where upper(name) like ''%PARTITION%'' ) --Change here
select ''?'' as FoundInDatabase, * from [?].sys.objects where upper(name) like ''%PARTITION%'' ' --Change here
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Find objects referencing an object, works only in a specific database
use x
go
SELECT DISTINCT o.name, schema_name(o.schema_id) schema_nm, o.type_desc, o.create_date, o.modify_date
FROM sys.syscomments c --Works only in the DB run
INNER JOIN sys.objects o ON c.id=o.object_id
WHERE c.TEXT LIKE '%SPbsmextractNAV%'--At Acadian, use below for more effective results
exec master.dbo.sp_objectsearch 'search-test' -- This proc exists in master on CORESp_helptext name-of-the-object --provide the text of an object--Other ways
SELECT DISTINCT
       o.name AS Object_Name,
       o.type_desc
  FROM sys.sql_modules m
       INNER JOIN
       sys.objects o
         ON m.object_id = o.object_id
 WHERE m.definition Like '%SELECT PerfDate, IndexId, PriceVariantId%';    --TO FIND STRING IN ALL PROCEDURES        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) SP_Name
              ,OBJECT_DEFINITION(OBJECT_ID) SP_Definition
        FROM   sys.procedures
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%SELECT PerfDate, IndexId, PriceVariantId%'
    END     --TO FIND STRING IN ALL VIEWS        
    BEGIN
        SELECT OBJECT_NAME(OBJECT_ID) View_Name
              ,OBJECT_DEFINITION(OBJECT_ID) View_Definition
        FROM   sys.views
        WHERE  OBJECT_DEFINITION(OBJECT_ID) LIKE '%SELECT PerfDate, IndexId, PriceVariantId%'
    END     --TO FIND STRING IN ALL FUNCTION        
    BEGIN
        SELECT ROUTINE_NAME           Function_Name
              ,ROUTINE_DEFINITION     Function_definition
        FROM   INFORMATION_SCHEMA.ROUTINES
        WHERE  ROUTINE_DEFINITION LIKE '%SELECT PerfDate, IndexId, PriceVariantId%'
               AND ROUTINE_TYPE = 'FUNCTION'
        ORDER BY
               ROUTINE_NAME
    END
------------------------------------------------------------------------------------------------------------------------------------------------------------