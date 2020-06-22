OPTIONS (SKIP = 1, ERRORS = 1)
  
load data
infile 'C:\MISC\SQL\mbta_temp_product_sales_smry\mbta_temp_product_sales_smry.csv'
BADFILE 'C:\MISC\SQL\mbta_temp_product_sales_smry\mbta_temp_product_sales_smry_bad.txt'

TRUNCATE 
into table MBTA_TEMP_product_sales_smry
fields terminated by "," optionally enclosed by '"'
TRAILING NULLCOLS             
(
DeviceClassId,
DeviceId,
UniqueMsId,
SalesTransactionNo
)