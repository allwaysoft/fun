OPTIONS (SKIP = 1, ERRORS = 1)
  
load data

infile 'C:\MISC\oracle\data\Corporate_Usage\input\RemovedFromAccount-20120214112303.csv'
BADFILE 'C:\MISC\oracle\sql\Corporate_Usage\RemovedFromAccount-20120214112303.bad'

TRUNCATE 
into table MBTA_TEMP_CORPORATE_USAGE_1
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
company_serialno "rtrim(ltrim(:company_serialno))"
)