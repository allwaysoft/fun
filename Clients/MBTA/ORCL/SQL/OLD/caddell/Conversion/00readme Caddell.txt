Instruction file for data conversion:

      The first two steps are done once for each data conversion session. 
      It may be easiest if you run sqlplusw from a DOS prompt from the directory where your conversion files are.
      (ie. d:\cm\2006\conversion> sqlplusw )
    1.in SQL Plus run command: start dcstart.sql
    2.in SQL Plus run command: set serveroutput on size 1000000
      The remaining steps should be done once for each table to be imported.
    3.in Windows: edit dcxxxxxx.bat (ie. dcbpartn.bat) to specify the correct version of sqlldr.exe and database connect string.
    4.in Windows: execute dcxxxxxx.bat (ie. dcbpartn.bat) for the desired import table.
    5.in SQL Plus run command: execute da.dbk_dc.verify('TABLE_NAME')

    - If there are no errors, data from temp table will be automatically move
	into the real table in 1 transaction without commit. You have to decide
	if you want to commit or rollback whole transaction. 
        (In SQL Plus either run command: commit;   or    rollback;  )


    - If you forgot to specified 'serveroutput on' all messages are stored in
	dc_import_status table.

    - To see all messages for the import of TABLE_NAME table run:

       SELECT DCIS_MESSAGE
         FROM DA.DC_IMPORT_STATUS
           WHERE upper(DCIS_TABLE_CODE) = 'DC_'||'TABLE_NAME'     (Make sure you have the single quotes and put the table_name in capitals)
           ORDER BY DCIS_DATE;


    - In DC_ERRORS table, there are errors for NAME_OF_TABLE table.

    - To see all different error types and their counts in the import for
	TABLE_NAME table run:

	SQL> START DCERR

	   or

	SQL> SELECT COUNT(*),
              DCERR_ERR_TYPE,
              DCERR_COLUMN_NAME,
              DCERR_DESCRIPTION
         FROM DA.DC_ERROR
           WHERE upper(DCERR_TABLE_NAME) = 'DC_'|| 'TABLE_NAME'   (Make sure you have the single quotes and put the table_name in capitals)
           GROUP BY DCERR_ERR_TYPE, DCERR_COLUMN_NAME, DCERR_DESCRIPTION;

    There are also two SQL scripts (errorsbyline.sql and errorsbytype.sql) that
    can be used to examine error messages in more detail.

    errorsbyline.sql - Asks you to enter the table name (without the 'DC_'
    prefix) and a first and last line (row) number.  It lists all of the errors
    for that table in the specified range of lines.  Note that rows in the table
    correspond to lines in the CSV file.

    errorsbytype.sql - Asks you to enter the table name (without the 'DC_'
    prefix) and the error type, which is shown in the summary query that you
    already have.  It lists all of the errors for that table and error type.

    To use these scripts, copy them to the same directory as your other
    executables and invoke them using the start command, for example:

    start errorsbyline

    Note that the ".sql" is optional.  SQL/Plus assumes this extension so you do
    not need to type it.





