/* -- Below can be used as column headers in the output file.
"CREATEDATE","PRODUCT","LOCATION","TICKETTYPE","ROUTE","DEVICEID","CASHVALUE","RIDERS","RIDER3AM","RIDER4AM","RIDER5AM","RIDER6AM","RIDER7AM","RIDER8AM","RIDER9AM","RIDER10AM",
"RIDER11AM","RIDER12PM","RIDER1PM","RIDER2PM","RIDER3PM","RIDER4PM","RIDER5PM","RIDER6PM","RIDER7PM","RIDER8PM","RIDER9PM","RIDER10PM","RIDER11PM","RIDER12AM","RIDER1AM","RIDER2AM"
*/
-- Will run for about 2 hrs.
set linesize 10000;
set pages 0 emb on newp none;
set feedback off;
set echo off;
set trimspool on;
set termout off;
set underline off;

/*
With Temp_Select as
(
select 1 as Col_Id,
'
"  CREATEDATE",
"  PRODUCT",
"  LOCATION",
"  TICKETTYPE",
"  ROUTE",
"  DEVICEID",
"  CASHVALUE",
"  RIDERS",
"  RIDER3AM",
"  RIDER4AM",
"  RIDER5AM",
"  RIDER6AM",
"  RIDER7AM",
"  RIDER8AM",
"  RIDER9AM",
"  RIDER10AM",
"  RIDER11AM",
"  RIDER12PM",
"  RIDER1PM",
"  RIDER2PM",
"  RIDER3PM",
"  RIDER4PM",
"  RIDER5PM",
"  RIDER6PM",
"  RIDER7PM",
"  RIDER8PM",
"  RIDER9PM",
"  RIDER10PM",
"  RIDER11PM",
"  RIDER12AM",
"  RIDER1AM",
"  RIDER2AM"
' as Col_Data
from dual 
UNION  
*/
/*
2 as col_id,
*/
select /*+ PARALLEL (mtg, 10) */
     '"' ||  CREATEDATE
|| '","' ||  PRODUCT
|| '","' ||  LOCATION
|| '","' ||  TICKETTYPE
|| '","' ||  ROUTE
|| '","' ||  DEVICEID
|| '","' ||  CASHVALUE
|| '","' ||  RIDERS
|| '","' ||  RIDER3AM
|| '","' ||  RIDER4AM
|| '","' ||  RIDER5AM
|| '","' ||  RIDER6AM
|| '","' ||  RIDER7AM
|| '","' ||  RIDER8AM
|| '","' ||  RIDER9AM
|| '","' ||  RIDER10AM
|| '","' ||  RIDER11AM
|| '","' ||  RIDER12PM
|| '","' ||  RIDER1PM
|| '","' ||  RIDER2PM
|| '","' ||  RIDER3PM
|| '","' ||  RIDER4PM
|| '","' ||  RIDER5PM
|| '","' ||  RIDER6PM
|| '","' ||  RIDER7PM
|| '","' ||  RIDER8PM
|| '","' ||  RIDER9PM
|| '","' ||  RIDER10PM
|| '","' ||  RIDER11PM
|| '","' ||  RIDER12AM
|| '","' ||  RIDER1AM
|| '","' ||  RIDER2AM 
|| '"' as data
from MBTA_TEMP_GATES_1_YEAR mtg;
/*
 ) 
Select Temp_Select.Col_Data
from temp_Select
Order By Temp_Select.Col_id ;  
*/
spool C:\MISC\ORACLE\data\Rob_Guptill_FareGates_Fareboxes_validators\output\one_year_gates_07-01-2011_07-01-2012.txt
/

spool off