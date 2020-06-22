OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\SQL\police_report\police_serial_empnumbers.csv'
BADFILE 'C:\MISC\ORACLE\SQL\police_report\police_serial_empnumbers.bad'

TRUNCATE 
into table MBTA_POLICE_INFORMATION
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
Police_ID, 
Police_Name, 
police_serialno
)