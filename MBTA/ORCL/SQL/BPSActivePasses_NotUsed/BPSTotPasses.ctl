OPTIONS (SKIP = 0, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\data\BPSActivePasses_NotUsed\input\BPSTotPasses022013.csv'
BADFILE 'C:\MISC\ORACLE\SQL\BPSActivePasses_NotUsed\BPSTotPasses_bad.bad'

TRUNCATE 
into table MBTA.MBTA_TEMP_BPSchool_TOT_PASSES
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
BPSTP_ID,  
BPSTP_serialno
)