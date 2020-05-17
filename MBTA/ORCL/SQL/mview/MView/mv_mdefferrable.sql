connect mbta/hallo@mvdb;

create or replace procedure alter_deferrable_constraint is

    cursor c2_cursor is
         select DC.owner,
                DC.table_name,
                DC.constraint_name,
                DC.r_owner,
                DC.r_constraint_name
           from user_constraints  DC
          where DC.constraint_type in ('R')
            and DC.table_name in
                   ('ACCESSLEVEL', 'ALARMACTION', 'ALARMEVENT', 'ALARMSERVERGROUP_ALARMEVENT', 'ARTICLE',
               	    'ARTICLE_RELEASE', 'BALANCEGROUP', 'CASHTYPE', 'COMPANY', 'CURRENCIES',
                    'DBCONNECTPARAMETER', 'DEFAULTSTATIONGROUP', 'DEVICECLASS', 'DEVICECLASS_VERSIONS', 'DEVICECONFIG',
                    'EVENT', 'EVENTGROUP', 'FEPDATA', 'FUNCTION', 'FUNCTIONGROUP',
                    'GRAPHICMAP', 'GRAPHICPROPERTY', 'HARDWARECOMPONENTS', 'JOBTABLE', 'LOCKDEPENDENCIES',
                    'MASTERASSEMBLY', 'MENUTREE', 'MULTIMEDIAGROUP', 'ORAERR', 'PAYMENTCASHTYPE',
                    'PAYMENTOPDATA', 'PERMDETAIL', 'PERMISSION', 'PREVIOUSPASSWORD', 'PREVIOUSPIN',
                    'RELEASE', 'RELEASE_VERSIONS', 'ROUTES', 'SCHEDULEELEMENT', 'SCHEDULEGROUP',
                    'SCHEDULEGROUPELEMENTS', 'SDRELEASE', 'SDRELEASE_RELEASE', 'STATUSOPTIONS', 'TABLEINFO',
                    'TARIFFVERSIONS', 'TVMFEPGROUP', 'TVMGROUP', 'TVMNETCONFGROUP', 'TVMSCHEDULEGROUPELEMENTS',
                    'TVMSTATION', 'TVMTABLE', 'TVMVERSIONGROUP', 'UNIQUENUMBERS', 'USERDATA',
                    'USERGROUPS', 'VERSIONGROUPLIST', 'VERSIONS', 'WORKSTATIONGRP', 'WORKSTATIONS',
                    'WSGRPCONTENTS'
                    );

    c2_rec  c2_cursor%rowtype;

    cursor c3_cursor is
          select DCC.column_name,
                 DCC.position
            from user_cons_columns DCC
           where DCC.constraint_name = c2_rec.constraint_name
           order by DCC.position;

    c3_rec  c3_cursor%rowtype;

    cursor c4_cursor is
          select DCC.table_name,
                 DCC.column_name,
                 DCC.position
            from user_cons_columns DCC
           where DCC.constraint_name = c2_rec.r_constraint_name
           order by DCC.position;

    c4_rec  c4_cursor%rowtype;

    col_field1  varchar2(200) := NULL;
    col_field2  varchar2(200) := NULL;
    sql_string  varchar2(2000) := NULL;

begin

    open c2_cursor;
    loop
       fetch c2_cursor
       into c2_rec;
       exit when c2_cursor%notfound;


       open c3_cursor;
       loop
          fetch c3_cursor
           into c3_rec;
           exit when c3_cursor%notfound;

           if c3_rec.position = '1' then

              col_field1 := col_field1 || c3_rec.column_name;
           else
              col_field1 := col_field1 || ',' || c3_rec.column_name;
           end if;

       end loop;
       close c3_cursor;

       open c4_cursor;
       loop
          fetch c4_cursor
           into c4_rec;
            exit when c4_cursor%notfound;

           if c4_rec.position = 1 then
              col_field2 := col_field2 || c4_rec.column_name;
           else
              col_field2 := col_field2 || ',' || c4_rec.column_name;
           end if;

       end loop;
       close c4_cursor;

    sql_string := 'Alter table ' || c2_rec.owner || '.' || c2_rec.table_name ||
                  ' drop constraint ' || c2_rec.constraint_name || ';';
    dbms_output.put_line(sql_string);

    sql_string := 'Alter table ' || c2_rec.owner || '.' || c2_rec.table_name || 
                  ' add (constraint ' || c2_rec.constraint_name ||
                  ' foreign key ( ' || col_field1 || ') references ' ||
                  c2_rec.r_owner || '.' || c4_rec.table_name ||
                  '(' || col_field2 || ') deferrable );';

    dbms_output.put_line(sql_string);

    col_field1 := NULL;
    col_field2 := NULL;

    end loop;
    close c2_cursor;

end;
/
set linesize 2000;
set serveroutput on size 1000000;
spool alter_constraints.sql;
execute alter_deferrable_constraint;
spool off;
--spool SB_Deferrable.log;
--@alter_constraints.sql;
--spool off;
