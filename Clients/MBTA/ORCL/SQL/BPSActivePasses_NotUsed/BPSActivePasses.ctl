OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\data\BPSActivePasses_NotUsed\input\BPSActivePasses022013.txt'
BADFILE 'C:\MISC\ORACLE\SQL\BPSActivePasses_NotUsed\BPSActivePasses_bad.bad'

TRUNCATE 
into table MBTA.MBTA_TEMP_BPSchool_ACT_PASSES
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
BPSAP_ID,  
BPSAP_serialno
)