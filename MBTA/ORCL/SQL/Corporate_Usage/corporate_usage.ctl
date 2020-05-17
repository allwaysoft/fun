OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\ORACLE\data\Corporate_Usage\input\Corporate_usage_input_02_13.csv'
BADFILE 'C:\MISC\ORACLE\SQL\Corporate_Usage\corporate_usage_bad.bad'

--infile 'C:\MISC\ORACLE\data\card_usage\card_usage.csv'
--badfile 'C:\MISC\ORACLE\data\card_usage\card_usage_bad.bad'

TRUNCATE 
into table MBTA_TEMP_CORPORATE_USAGE
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
company_id "ltrim(:company_id )", 
company_Name "rtrim(ltrim(:company_Name))", 
company_serialno "rtrim(ltrim(:company_serialno))"
)