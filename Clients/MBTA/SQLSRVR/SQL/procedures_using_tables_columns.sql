select name from sys.procedures
where OBJECT_DEFINITION(object_id) like '%CONTENT%'
--and OBJECT_DEFINITION(object_id) like '%WHERE%CONTENT_TITLE%'
and OBJECT_DEFINITION(object_id) like '%WHERE%FOLDER_ID%'
order by name

SELECT OBJECT_NAME(object_id) FROM sys.sql_modules WHERE upper(definition) LIKE '%TIMETABLE%' 