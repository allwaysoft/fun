select * from function order by functionid desc

select * from menutree order by menuitemid desc

select * from permission

delete from menutree where menuitemid = 602

select menuitemid from menutree 
where 1=1 
and mainmenuref = 52
and menuitemtext = 'Usage and Ridership Reports'
--and functionref = 397
order by menuitemid desc

select * from permission where functionref = 402 order by functionref desc

select * from usergroups order by usergroupid

select * from functiongroup

select * from menutree

-----------------------
-- Do the below in test for inserting a new report-------------
-----------------------
insert into function
values((select max(functionid)+1 from function), --(should be max functionid value in the table + 1)
          null, 
          'Exits:Day of Week Station Summary', 
          1, --always 1
          6, -- always 6
          'Report.bmp', 
          'MBTA_ExitsDayofWeekStationSummary.exe %UN %DB %PW %PL S&B Exits_Day_of_Week_Station_Sumamry MBTA_ExitsDayofWeekStationSummary.rdf',
          null ,
          null ,
          null , 
          9, -- This always 9. 9 is for reports.
          1, 
          2, 
          '4711', -- User entering the data into table. Leave as is
          sysdate,
          null ,
          null ,
          null ,
          null ,
          null
        )

insert into menutree
values((select max(menuitemid)+1 from menutree), --(should be max value from the table + 1)
         'Exits:Day of Week Station Summary',
         1, 
         (select menuitemid from menutree where 1=1 and usernew = '4711' /* mainmenuref = 52  52 is for Reports only in test*/ and menuitemtext = 'Usage and Ridership Reports'), 
                                                                                                           --(Menu tree group under which the report should go) -- This column references menuitemid column of menutree table. So to know what 209 is 
         'Exits:Day of Week Station Summary', 
         null, 
         (select max(functionid) from function), --(Here we use max but not max+1 because by running the above insert into Function table, the max value in the function table is of the new report.)
         (select max(ordernumber)+1 from menutree
          where mainmenuref = (select menuitemid 
                                               from menutree 
                                             where 1=1 
                                                and usernew = '4711'                   --mainmenuref = 52 /* 52 is for Reports only in test 
                                                and menuitemtext = 'Usage and Ridership Reports'
                                            )),    --Order of display in the menue tree (order in particular group) 
         '4711', --User entering the data into table. Leave as is 
         sysdate, 
         null, 
         null, 
         null)


insert into permission
values((select usergroupid from usergroups where usergroupdesc = 'Planning'), -- (user group to whom permission to be granted )   MBTA CCS Administrator AFC Staff          AFC Staff = 9999992 in production       Planning 
         (select max(functionid) from function), --(Here we use max but not max+1 because by running the above insert into Function table, the max value in the function table is of the new report.)
         0, 
         0, 
         null, 
         '4711',  -- User entering the data into table. Leave as is
         sysdate, 
         null, 
         null
        )
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------        





select * from usergroups order by usergroupid

commit

select * from permission where functionref = 402

select menuitemid from menutree where 1=1 and usernew = 4711 /* 52 is for Reports*/ and menuitemtext = 'Usage and Ridership Reports'

select * from menutree 
where 1=1
--and mainmenuref = 52 
and menuitemname like 'REPORT%'

EXITS TYPE AND TIME OF DAY STATION     1    209    Exits Type and Time of Day Station 

select * from menutree where menuitemid = 209

select * from menutree where menuitemid = 400

select * from menutree where menuitemid = 52

select * from menutree where menuitemid = 504

select * from menutree where menuitemid = 500

select * from menutree where menuitemtext = 'Usage and Ridership Reports'

SELECT FUNCTIONID || ', ' ||
  DBCONNECTPARAMETERID|| ', '  ||
  '''' || FUNCTIONDESC ||'''' || ', ' ||
  FUNCTIONCLASS|| ', ' ||
  FUNCTIONTYPE|| ', ' ||
  '''' || BITMAPREF ||'''' || ', ' ||
  '''' || COMMANDREF ||'''' ||  ', ' ||
  '''' || MESSAGENUMBER ||'''' ||  ', ' ||
  '''' || MESSAGEDEST ||'''' ||  ', ' ||
  MESSAGECMD|| ', ' ||
  FUNCTIONGROUPREF|| ', ' ||
  LOCKINGTYPE|| ', ' ||
  DEPENDENCYTYPE|| ', ' ||
  '''4711''' || ', ' ||
      'sysdate, ' ||
  '''' || USERCHANGE ||'''' || ', ' ||
  TIMECHANGE|| ', ' ||
  '''' || FILEREFERENCE ||'''' || ', ' ||
  FUNCTIONIDREF|| ', ' ||
  '''' || WINDOWTITLE ||''''
FROM FUNCTION
where functionid = 397


SELECT MENUITEMID|| ', ' ||
  '''' || MENUITEMNAME||'''' || ', ' ||
  MENUTYPE|| ', ' ||
  MAINMENUREF|| ', ' ||
  '''' || MENUITEMTEXT||'''' || ', ' ||
  'null, '||
  FUNCTIONREF|| ', ' ||
  ORDERNUMBER|| ', ' ||
  '''4711''' || ', ' ||
      'sysdate, ' ||
  'null, '||
  'null, '||
  'null '
FROM MENUTREE  where functionref = 397


SELECT USERGROUPREF|| ', ' ||
  FUNCTIONREF|| ', ' ||
  RESTRICTWORKSTAT|| ', ' ||
  SHOWBITMAP|| ', ' ||
  'null, '||
  '''4711''' || ', ' ||
      'sysdate, ' ||
  'null, '||
  'null'
FROM PERMISSION where functionref = 397

select * from function where functionid = (select max(functionid) from function)

select * from menutree 
where mainmenuref = 209
--and functionref = 397
order by menuitemid desc

(select max(ordernumber)+1 from menutree
where mainmenuref = (select menuitemid 
                                    from menutree 
                                  where 1=1 
                                      and mainmenuref = 52 /* 52 is for Reports*/ 
                                      and menuitemtext = 'Usage and Ridership Reports'
                                 ))
                                 
                                 
                                 select length('MBTA Exits: Type and Time of Day Station Summary') from dual
