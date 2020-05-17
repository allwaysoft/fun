OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\data\hotlist\input\hotlist_StudentIds_withjuly_iusage_and_valid_dates.csv'
BADFILE 'C:\MISC\SQL\hotlist\hotlist_StudentIds_withjuly_iusage_and_valid_dates.bad'

APPEND 
into table MBTA.hotlist
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
MEDIATYPE,
SERIALNUMBER,
XVALIDFROM "to_date(:XVALIDFROM,'MM/DD/YYYY')",
SERIALNUMBERUB,
SREASON,
XVALIDUNTIL "to_date(:XVALIDUNTIL ,'MM/DD/YYYY')",
STATUS,
USERNEW,
TIMENEW "to_date(:TIMENEW,'MM/DD/YYYY HH:MI')",
USERCHANGE,
TIMECHANGE "to_date(:TIMECHANGE,'MM/DD/YYYY HH:MI')"
)
