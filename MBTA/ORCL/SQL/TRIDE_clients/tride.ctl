OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\SQL\tride_clients\input\tride.csv'
BADFILE 'C:\MISC\SQL\tride_clients\tride.bad'

TRUNCATE 
into table MBTA.MBTA_TEMP_tride
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
clientid,
lastname,
firstname,
middleinitial,
email,
houseno,
address1,
address2,
city,
state,
zipcode,
UDF
)