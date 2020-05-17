Example: 1
/*
The one example below (Example: 2) the current (Example: 1) one works, but it has an issue because you cannot use VSIZE on BLOB data columns, and it could be re-done using dbms_lob.getlength(BLOB_COLUMN) to get an accurate average_row_length for rows with a BLOB column..

To find the actual size of a row I did this:
*/

/* TABLE */
select
3 + avg(nvl(dbms_lob.getlength(CASE_DATA),0)+1 +
               nvl(vsize(CASE_NUMBER   ),0)+1 +
               nvl(vsize(CASE_DATA_NAME),0)+1 +
               nvl(vsize(LASTMOD_TIME_T),0)+1
              ) "Total bytes per row"
from 
   arch_case_data
where 
   case_number = 301;

Total bytes per row
--------------------
                3424 

/* INDEX */
 select sum(COLUMN_LENGTH)
   from dba_ind_columns
  where  TABLE_NAME = 'ARCH_CASE_DATA';

SUM(COLUMN_LENGTH)
------------------------
                      22 

So, the total bytes used is 3424+22.



Example: 2
/*
Disclaimer: Use these scripts and/or any recommendations they may contain at your own risk. These scripts may or may not have been tested. 

Title: Calculating the Average Row Size

Author:Venkat Kambalapally, a DBA for Greenbrier and Russel in Atlanta, Georgia.

Often DBAs need to estimate the average row size for a table or tables. One way of getting this information is to analyzed the
table schema and checking the avg_row_size column. Another method is to write a statement that calculates the average of the
VSIZE for all columns in a particular table. It is very tedious to write a script specifying all the columns for a large table--let
alone a database with hundreds of tables. This script spools a script file that can be used to calculate the average row size for
an entire schema.

Note: Copy the code and save it as a .sql file, then call the file from SQL*Plus. The script prompts for a spool file name. The
script works on both Oracle7 Release 3 and Oracle8 Release 8.0.3.
Source/Text/Comments
*/

REM       GENERATES THE STATEMENTS TO CALCULATE AVERAGE ROW SIZE FOR ALL
REM   TABLES IN THE CURRENT SCHEMA
SET HEADING OFF
SET SERVEROUTPUT ON
ACCEPT filename PROMPT 'Enter the Path and File Name for the Script => '
PROMPT
PROMPT Generating script for calculating Average Row Size.....
SET TERMOUT OFF
SPOOL &&filename
DECLARE
 i INT;
 colid INT;
 maxcolid INT;
 tabname VARCHAR2(30);
 colname VARCHAR2(30);
 vsizestmt varchar2(1000);
 CURSOR tabs_cur IS SELECT table_name from user_tables;
 CURSOR cols_cur(tname VARCHAR2) IS SELECT column_name,column_id FROM
    user_tab_columns WHERE table_name=tname ORDER BY column_id;
BEGIN
 dbms_output.enable(1000000);
 dbms_output.put_line('SET SERVEROUTPUT ON');
 dbms_output.put_line('SET FEEDBACK OFF');
     OPEN tabs_cur;
         LOOP
           FETCH tabs_cur INTO tabname;
         EXIT WHEN tabs_cur%NOTFOUND;
         BEGIN
            SELECT MAX(column_id) INTO maxcolid FROM user_tab_columns WHERE
               table_name=tabname;
            OPEN cols_cur(tabname);
                vsizestmt:='SELECT ';
                dbms_output.put_line('REM Start '||tabname);
                dbms_output.put_line('REM *******************************************************');
                dbms_output.put_line('PROMPT Table: '||tabname);
                dbms_output.put_line(vsizestmt);
              LOOP
                FETCH cols_cur INTO colname,colid;
                EXIT WHEN cols_cur%NOTFOUND;
                  vsizestmt:='DECODE(AVG(VSIZE('||colname||')),NULL,0,AVG(VSIZE('||colname||')))'||'+';
                  IF colid < maxcolid  THEN
                        dbms_output.put_line(vsizestmt);
                ELSE
                BEGIN
                        dbms_output.put_line(substr(vsizestmt,1,(length(vsizestmt)-1)));
                END;
                END IF;
             END LOOP;
            CLOSE cols_cur;
                vsizestmt:='AVERAGE_ROW_SIZE FROM '||tabname||';';
                dbms_output.put_line(vsizestmt);
                dbms_output.put_line('REM End '||tabname);
                dbms_output.put_line('REM ******************************************************');
        END;
        END LOOP;
    CLOSE tabs_cur;
 dbms_output.put_line('SET HEADING ON');
 dbms_output.put_line('SET FEEDBACK ON');
 dbms_output.put_line('SET TERMOUT ON');
END;
/

SPOOL OFF
SET FEEDBACK ON
SET HEADING ON
SET TERMOUT ON
PROMPT
PROMPT Generated script &&filename
PROMPT Run the file &&filename to calculate Average Row Size
PROMPT
UNDEF filename
UNDEF tabname


