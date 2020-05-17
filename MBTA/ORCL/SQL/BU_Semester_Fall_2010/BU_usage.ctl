OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\SQL\BU_Semester_Fall_2010\BU_usage.txt'
BADFILE 'C:\MISC\SQL\BU_Semester_Fall_2010\BU_usage.txt'

TRUNCATE 
into table MBTA.MBTA_TEMP_BU_USAGE
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
BU_SEQUENCENO, 
BU_serialno
)