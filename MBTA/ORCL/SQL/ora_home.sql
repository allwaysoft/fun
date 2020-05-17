    
SELECT substr(file_spec,1,instr(file_spec,'lib')-2) ORACLE_HOME FROM dba_libraries 
WHERE library_name='DBMS_SUMADV_LIB';

SELECT value  FROM v$parameter WHERE name = 'user_dump_dest'; 
